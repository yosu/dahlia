defmodule DahliaWeb.WaterBillController do
  use DahliaWeb, :controller

  alias Dahlia.Bill

  def show(conn, %{"id" => id}) do
    e = Bill.get_water_bill_evidence!(id)

    conn
    |> put_resp_content_type(e.content_type)
    |> send_resp(200, e.data)
  end
end
