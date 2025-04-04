defmodule DahliaWeb.WaterBillLive do
  alias DahliaWeb.Endpoint
  use DahliaWeb, :live_view

  alias Dahlia.Bill
  alias DahliaWeb.Endpoint

  @evidence_topic "evidence_topic"

  def render(assigns) do
    ~H"""
    <h1 class="p-2 text-center text-2xl">{@page_title}</h1>
    <div class="mb-2">
      <.link patch={~p"/water/new"}>
        <.button>アップロード</.button>
      </.link>
    </div>
    <hr />
    <div id="evidence-list" phx-update="stream">
      <div :for={{dom_id, evidence} <- @streams.evidences} id={dom_id} class="p-2">
        <img
          phx-click={JS.patch(~p"/water/#{evidence.id}/summary/new")}
          src={~p"/water/evidences/#{evidence}"}
          width="800"
          class="cursor-pointer border-4 border-transparent hover:border-4 hover:border-brand"
        />
        <.link
          class="text-red-500"
          phx-click={JS.push("delete", value: %{"id" => evidence.id})}
          data-confirm="本当に削除しますか？"
        >
          削除
        </.link>
      </div>
    </div>
    <.modal
      :if={@live_action in [:new]}
      show
      id="water-bill-evidence-modal"
      on_cancel={JS.patch(~p"/water")}
    >
      <.live_component
        module={DahliaWeb.WaterBillLive.EvidenceForm}
        id={:new}
        title={@page_title}
        current_user={@current_user}
      />
    </.modal>
    <.modal
      :if={@live_action in [:summary_new]}
      show
      id="water-bill-summary-modal"
      on_cancel={JS.patch(~p"/water")}
    >
      <.live_component
        module={DahliaWeb.WaterBillLive.SummaryForm}
        id={:summary_new}
        title={@page_title}
        current_user={@current_user}
        summary={@summary}
        evidence_id={@evidence_id}
      />
    </.modal>
    """
  end

  def mount(_param, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(topic(socket))
    end

    {:ok,
     socket
     |> stream(:evidences, Bill.water_bill_evidence_list(socket.assigns.current_user))}
  end

  defp topic(socket) do
    user = socket.assigns.current_user
    @evidence_topic <> ":" <> user.id
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _parmas) do
    socket
    |> assign(:page_title, "水道料金・検針票のアップロード")
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "未処理の水道料金・検針表")
  end

  defp apply_action(socket, :summary_new, %{"evidence_id" => evidence_id}) do
    socket
    |> assign(:page_title, "水道料金・検針票の記録")
    |> assign(:evidence_id, evidence_id)
    |> assign(:summary, %Dahlia.Bill.WaterBillSummary{})
  end

  def handle_info({DahliaWeb.WaterBillLive.EvidenceForm, {:saved, evidence}}, socket) do
    Endpoint.broadcast(topic(socket), "evidence_saved", %{evidence: evidence})

    {:noreply, socket}
  end

  def handle_info({DahliaWeb.WaterBillLive.SummaryForm, {:saved, summary}}, socket) do
    IO.inspect(summary, label: "SummaryForm")
    Endpoint.broadcast(topic(socket), "summary_saved", %{summary: summary})

    {:noreply, socket}
  end

  def handle_info(%{event: "evidence_saved", payload: %{evidence: evidence}}, socket) do
    {:noreply, stream_insert(socket, :evidences, evidence)}
  end

  def handle_info(%{event: "evidence_deleted", payload: %{evidence: evidence}}, socket) do
    {:noreply, stream_delete(socket, :evidences, evidence)}
  end

  def handle_info(%{event: "summary_saved", payload: %{summary: summary}}, socket) do
    IO.inspect(summary, label: "summary_saved")
    {:noreply, stream_delete(socket, :evidences, %{id: summary.evidence_id})}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    evidence = Bill.get_water_bill_evidence!(id)
    {:ok, _deleted} = Bill.delete_water_bill_evidence(evidence)

    Endpoint.broadcast(topic(socket), "evidence_deleted", %{evidence: evidence})

    {:noreply, socket}
  end
end
