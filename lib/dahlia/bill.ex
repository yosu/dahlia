defmodule Dahlia.Bill do
  @moduledoc false
  alias Dahlia.Bill.WaterBillEvidence
  alias Dahlia.Bill.WaterBillEvidenceData
  alias Dahlia.Bill.WaterBillSummary
  alias Dahlia.Repo
  alias Dahlia.Image

  import Ecto.Query

  @doc """
  Gets a single evidence.
  """
  def get_water_bill_evidence!(id) do
    Repo.get!(WaterBillEvidence, id)
  end

  def get_water_bill_evidence_data_by_evidence_id!(evidence_id) do
    Repo.get_by!(WaterBillEvidenceData, evidence_id: evidence_id)
  end

  def get_water_bill_evidence_with_data(id) do
    query =
      from e in WaterBillEvidence,
        join: d in assoc(e, :data),
        preload: [data: d],
        where: e.id == ^id

    Repo.one(query)
  end

  @doc """
  Returns the list of evidences belongs to the user.
  """
  def water_bill_evidence_list(user) do
    query =
      from e in WaterBillEvidence,
        where: e.user_id == ^user.id,
        order_by: {:desc, :inserted_at}

    Repo.all(query)
  end

  @doc """
  Returns the list of water bill evidences which has no summary.
  """
  def outstanding_water_bill_evidence_list(user) do
    query =
      from e in WaterBillEvidence,
        left_join: s in WaterBillSummary,
        on: s.evidence_id == e.id,
        where: is_nil(s.evidence_id) and e.user_id == ^user.id

    Repo.all(query)
  end

  def water_bill_summary_list(user) do
    query =
      from s in WaterBillSummary,
        join: e in WaterBillEvidence,
        on: s.evidence_id == e.id,
        where: e.user_id == ^user.id

    Repo.all(query)
  end

  @doc """
  Save the uploaded file into the database.
  """
  def save_water_bill_evidence_from_upload(path, name, user) do
    {:ok, data} = File.read(path)

    {compact_name, compact_data} = Image.compact!(name, data)

    {:ok, _evidence} =
      save_water_bill_evidence(%{name: compact_name, data: compact_data, user: user})
  end

  @doc """
  Save the evidence data.
  """
  def save_water_bill_evidence(%{name: name, data: data, user: user}) do
    Repo.transaction(fn ->
      evidence =
        WaterBillEvidence.new_changeset(%{
          name: name,
          content_type: MIME.from_path(name),
          content_length: byte_size(data),
          digest: WaterBillEvidence.digest(data),
          user_id: user.id
        })
        |> Repo.insert!()

      WaterBillEvidenceData.new_changeset(%{data: data, evidence_id: evidence.id})
      |> Repo.insert!()

      evidence
    end)
  end

  @doc """
  Deletes a evidence.
  """
  def delete_water_bill_evidence(%WaterBillEvidence{} = evidence) do
    Repo.delete(evidence)
  end

  @doc """
  Returns WaterBillSummary changeset.
  """
  def change_summary(%WaterBillSummary{} = summary, attrs \\ %{}) do
    WaterBillSummary.changeset(summary, attrs)
  end

  def create_summary(attrs \\ %{}) do
    %WaterBillSummary{}
    |> WaterBillSummary.changeset(attrs)
    |> Repo.insert()
  end

  def update_summary(%WaterBillSummary{} = summary, attrs \\ %{}) do
    summary
    |> WaterBillSummary.changeset(attrs)
    |> Repo.update()
  end

  def get_water_bill_summary_by_evidence_id!(evidence_id) do
    Repo.get_by!(WaterBillSummary, evidence_id: evidence_id)
  end
end
