defmodule DahliaWeb.GasBillLive do
  use DahliaWeb, :live_view

  alias Dahlia.Bill
  alias Dahlia.Bill.GasBillEvidence
  alias Dahlia.Bill.GasBillSummary
  alias DahliaWeb.Endpoint

  import DahliaWeb.LiveHelper
  import DahliaWeb.GasBillLive.Component

  @topic "gas_bill_live"

  def mount(_param, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(topic(@topic, socket))
    end

    user = socket.assigns.current_user

    {:ok, socket
     |> stream(:evidences, Bill.outstanding_gas_bill_evidence_list(user))
     |> assign_summaries()
  }
  end

  defp assign_summaries(socket) do
    assign(socket, :summaries, Bill.gas_bill_summary_list(socket.assigns.current_user))
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _parmas) do
    assign(socket, :page_title, "ガス料金・使用量のアップロード")
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "ガス料金・使用量")
  end

  defp apply_action(socket, :summary, _params) do
    assign(socket, :page_title, "ガス料金・使用量")
  end

  defp apply_action(socket, :summary_new, %{"evidence_id" => evidence_id}) do
    socket
    |> assign(:page_title, "ガス料金・使用量の記録")
    |> assign(:evidence_id, evidence_id)
    |> assign(:summary, %Dahlia.Bill.GasBillSummary{})
  end

  defp apply_action(socket, :summary_edit, %{"evidence_id" => evidence_id}) do
    summary = Bill.get_gas_bill_summary_by_evidence_id!(evidence_id)

    socket
    |> assign(:page_title, "ガス料金・使用量の記録")
    |> assign(:evidence_id, evidence_id)
    |> assign(:summary, summary)
  end

  def handle_info({DahliaWeb.EvidenceLive.FormComponent, {:saved, evidence}}, socket) do
    Endpoint.broadcast(topic(@topic, socket), "evidence_saved", %{evidence: evidence})

    {:noreply, socket}
  end

  def handle_info(%{event: "evidence_saved", payload: %{evidence: evidence}}, socket) do
    {:noreply, stream_insert(socket, :evidences, evidence)}
  end

  def handle_info(%{event: "evidence_deleted", payload: %{evidence: evidence}}, socket) do
    {:noreply, stream_delete(socket, :evidences, evidence)}
  end

  def handle_info({DahliaWeb.GasBillLive.SummaryForm, {:saved, summary}}, socket) do
    Endpoint.broadcast(topic(@topic, socket), "summary_saved", %{summary: summary})

    {:noreply, socket}
  end

  def handle_info({DahliaWeb.GasBillLive.SummaryForm, {:updated, summary}}, socket) do
    Endpoint.broadcast(topic(@topic, socket), "summary_updated", %{summary: summary})

    {:noreply, socket}
  end

  def handle_info(%{event: "summary_saved", payload: %{summary: summary}}, socket) do
    {:noreply,
     socket
     |> stream_delete(:evidences, %{id: summary.evidence_id})
     |> assign_summaries()}
  end

  def handle_info(%{event: "summary_updated", payload: %{summary: _summary}}, socket) do
    {:noreply, assign_summaries(socket)}
  end

  def handle_info(%{event: "summary_deleted", payload: %{summary: _summary}}, socket) do
    {:noreply, assign_summaries(socket)}
  end

  def handle_event("delete", %{"id" => evidence_id}, socket) do
    with summary = %GasBillSummary{} <- Bill.get_gas_bill_summary_by_evidence_id(evidence_id),
         {:ok, _deleted} <- Bill.delete_gas_bill_summary(summary) do
      Endpoint.broadcast(topic(@topic, socket), "summary_deleted", %{summary: summary})
    end

    evidence = Bill.get_gas_bill_evidence!(evidence_id)
    {:ok, _deleted} = Bill.delete_gas_bill_evidence(evidence)

    Endpoint.broadcast(topic(@topic, socket), "evidence_deleted", %{evidence: evidence})

    {:noreply, socket}
  end
end
