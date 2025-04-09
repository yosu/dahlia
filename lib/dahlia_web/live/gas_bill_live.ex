defmodule DahliaWeb.GasBillLive do
  use DahliaWeb, :live_view

  alias Dahlia.Bill
  alias Dahlia.Bill.GasBillEvidence
  alias DahliaWeb.Endpoint

  import DahliaWeb.LiveHelper

  @topic "gas_bill_live"

  def mount(_param, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(topic(@topic, socket))
    end

    user = socket.assigns.current_user

    {:ok, socket

     |> stream(:evidences, Bill.outstanding_gas_bill_evidence_list(user))
  }
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

  def handle_event("delete", %{"id" => evidence_id}, socket) do
    # with summary = %WaterBillSummary{} <- Bill.get_water_bill_summary_by_evidence_id(evidence_id),
    #      {:ok, _deleted} <- Bill.delete_water_bill_summary(summary) do
    #   Endpoint.broadcast(topic(@topic, socket), "summary_deleted", %{summary: summary})
    # end

    evidence = Bill.get_gas_bill_evidence!(evidence_id)
    {:ok, _deleted} = Bill.delete_gas_bill_evidence(evidence)

    Endpoint.broadcast(topic(@topic, socket), "evidence_deleted", %{evidence: evidence})

    {:noreply, socket}
  end
end
