defmodule DahliaWeb.GasBillLive do
  use DahliaWeb, :live_view

  alias Dahlia.Bill.GasBillEvidence

  def mount(_param, _session, socket) do
    {:ok, socket}
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
end
