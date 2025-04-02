defmodule DahliaWeb.WaterBillLive do
  use DahliaWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="p-2 text-center text-2xl">{@page_title}</h1>
    <div class="mb-2">
      <.link patch={~p"/water/new"}>
        <.button>作成</.button>
      </.link>
    </div>
    <hr />
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
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _parmas) do
    socket
    |> assign(:page_title, "新規作成")
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "水道料金一覧")
  end
end
