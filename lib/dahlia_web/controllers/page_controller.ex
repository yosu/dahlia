defmodule DahliaWeb.PageController do
  use DahliaWeb, :controller

  def home(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/water")
    else
      render(conn, :home, layout: false)
    end
  end
end
