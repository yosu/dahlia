defmodule Dahlia.Bill do
  @moduledoc false
  alias Dahlia.Bill.WaterBillEvidence
  alias Dahlia.Bill.WaterBillEvidenceData
  alias Dahlia.Repo
  alias Dahlia.Image

  @doc """
  Gets a signle evidence.
  """
  def get_water_bill_evidence!(id) do
    Repo.get!(WaterBillEvidence, id)
  end

  def get_water_bill_evidence_with_data(id) do
    WaterBillEvidence.Query.with_data()
    |> WaterBillEvidence.Query.by_id(id)
    |> Repo.one()
  end

  @doc """
  Returns the list of evidences.
  """
  def water_bill_evidence_list() do
    Repo.all(WaterBillEvidence.Query.order_by_inserted_at())
  end

  @doc """
  Save the uploaded file into the database.
  """
  def save_water_bill_evidence_from_upload(path, name) do
    {:ok, data} = File.read(path)

    {compact_name, compact_data} = Image.compact!(name, data)

    save_water_bill_evidence(%{name: compact_name, data: compact_data})
  end

  @doc """
  Save the evidence data.
  """
  def save_water_bill_evidence(%{name: name, data: data}) do
    Repo.transaction(fn ->
      evidence_data =
        WaterBillEvidenceData.new_changeset(%{data: data})
        |> Repo.insert!()

      WaterBillEvidence.new_changeset(%{
        name: name,
        data_id: evidence_data.id,
        content_type: MIME.from_path(name),
        content_length: byte_size(data),
        digest: digest(data)
      })
      |> Repo.insert!()
    end)
  end

  defp digest(data) do
    :crypto.hash(:md5, data)
    |> Base.encode64()
    |> then(&("md5-" <> &1))
  end

  @doc """
  Deletes a evidence.
  """
  def delete_water_bill_evidence(%WaterBillEvidence{} = evidence) do
    Repo.delete(evidence)
  end
end
