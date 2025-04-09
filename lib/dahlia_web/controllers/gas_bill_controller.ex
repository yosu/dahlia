defmodule DahliaWeb.GasBillController do
  use DahliaWeb, :controller

  alias Dahlia.Bill

  def show(conn, %{"id" => id}) do
    case Bill.get_gas_bill_evidence(id) do
      nil ->
        conn
        |> send_resp(:not_found, "")

      evidence ->
        if evidence.digest in get_req_header(conn, "if-none-match") do
          send_resp(conn, 304, "")
        else
          data = Bill.get_gas_bill_evidence_data_by_evidence_id!(id)

          conn
          |> put_resp_header("cache-control", "private")
          |> put_resp_header("etag", evidence.digest)
          |> put_resp_content_type(evidence.content_type)
          |> send_resp(200, data.data)
        end
    end
  end
end
