defmodule Dahlia.Bill do
  alias Dahlia.Bill.WaterBillEvidence
  alias Dahlia.Repo

  def water_bill_evidence_list() do
    Repo.all(WaterBillEvidence.Query.order_by_inserted_at())
  end

  @doc """
  Save the uploaded file into the database.
  """
  def save_water_bill_evidence_from_path(path, name, content_type) do
    {:ok, data} = File.read(path)

    save_water_bill_evidence(%{
      name: name,
      content_type: content_type,
      data: data,
    })
  end

  @doc """
  Save the evidence data.
  """
  def save_water_bill_evidence(%{name: name, content_type: content_type, data: data}) do
    WaterBillEvidence.new_changeset(%{
      name: name,
      data: data,
      content_type: content_type,
      content_length: byte_size(data),
      digest: digest(data)
    })
    |> Repo.insert()
  end

  defp digest(data) do
    :crypto.hash(:md5, data)
    |> Base.encode64()
    |> then(&("md5-" <> &1))
  end
end
