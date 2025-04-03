defmodule DahliaWeb.WaterBillLive do
  use DahliaWeb, :live_view

  alias Dahlia.Bill

  def render(assigns) do
    ~H"""
    <h1 class="p-2 text-center text-2xl">{@page_title}</h1>
    <div class="mb-2">
      <.link patch={~p"/water/new"}>
        <.button>アップロード</.button>
      </.link>
    </div>
    <hr />
    <div id="evidence-list" phx-update="stream"  >
      <div :for={{dom_id, evidence} <- @streams.evidences} id={dom_id}>
        {evidence.id} {evidence.name}
      </div>
    </div>
    <.modal
      :if={@live_action in [:new]}
      show
      id="water-bill-evidence-modal"
      on_cancel={JS.patch(~p"/water")}
    >
      <.live_component
        module={DahliaWeb.WaterBillLive.FormComponent}
        id={:new}
        title={@page_title}
       />
    </.modal>
    """
  end

  def mount(_param, _session, socket) do
    {:ok,
    socket
    |> stream(:evidences, Bill.water_bill_evidence_list())
  }
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
    |> assign(:page_title, "水道料金一覧")
  end

  def handle_info({DahliaWeb.WaterBillLive.FormComponent, {:saved, evidence}}, socket) do
    {:noreply,
      socket
      |> stream_insert(:evidences, evidence)}
  end
end
