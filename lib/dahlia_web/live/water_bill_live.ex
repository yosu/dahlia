defmodule DahliaWeb.WaterBillLive do
  use DahliaWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Hello water bills</h1>
    """
  end

  def mount(_param, _session, socket) do
    {:ok, socket}
  end
end
