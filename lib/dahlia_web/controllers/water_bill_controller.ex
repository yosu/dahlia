defmodule DahliaWeb.WaterBillController do
  use DahliaWeb, :controller

  alias Dahlia.Bill

  def show(conn, %{"id" => id}) do
    case Bill.get_water_bill_evidence_with_data(id) do
      nil ->
        conn
        |> send_resp(:not_found, "")

      evidence ->
        conn
        |> put_resp_content_type(evidence.content_type)
        |> send_resp(200, evidence.data.data)
    end
  end
end
