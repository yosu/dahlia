defmodule Dahlia.Bill do
  alias Dahlia.Bill.WaterBillEvidence
  alias Dahlia.Repo

  def save_water_bill_evidence(path, entry) do
    {:ok, data} = File.read(path)
    %{
      client_name: name,
      client_size: content_length,
      client_type: content_type
    } = entry
    digest = digest(data)

    WaterBillEvidence.new_changeset(%{
      name: name,
      data: data,
      content_type: content_type,
      content_length: content_length,
      digest: digest
    })
    |> Repo.insert()
  end

  defp digest(data) do
    :crypto.hash(:md5, data)
    |> Base.encode64()
    |> then(&("md5-" <> &1))
  end
end
