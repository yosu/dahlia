defmodule Dahlia.Bill do
  @moduledoc false
  alias Dahlia.Bill.GasBillSummary
  alias Dahlia.Bill.GasBillEvidence
  alias Dahlia.Bill.GasBillEvidenceData
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

  @doc """
  Gets a single evidence.
  """
  def get_water_bill_evidence(id) do
    Repo.get(WaterBillEvidence, id)
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

  def outstanding_gas_bill_evidence_list(user) do
    query =
      from e in GasBillEvidence,
        left_join: s in GasBillSummary,
        on: s.evidence_id == e.id,
        where: is_nil(s.evidence_id) and e.user_id == ^user.id

    Repo.all(query)

  end

  def water_bill_summary_list(user) do
    query =
      from s in WaterBillSummary,
        join: e in WaterBillEvidence,
        on: s.evidence_id == e.id,
        where: e.user_id == ^user.id,
        order_by: {:desc, s.bill_date}

    Repo.all(query)
  end

  @doc """
  Save the uploaded file into the database.
  """
  def save_bill_evidence_from_upload(evidence_mod, path, name, user) do
    {:ok, data} = File.read(path)

    {compact_name, compact_data} = Image.compact!(name, data)

    {:ok, _evidence} =
      save_bill_evidence(evidence_mod, %{name: compact_name, data: compact_data, user: user})
  end

  @doc """
  Save the evidence data.
  """
  def save_water_bill_evidence(%{} = attrs) do
    save_bill_evidence(WaterBillEvidence, attrs)
  end

  defp save_bill_evidence(evidence_mod, %{name: name, data: data, user: user}) do
    Repo.transaction(fn ->
      evidence =
        apply(evidence_mod, :new_changeset, [
          %{
            name: name,
            content_type: MIME.from_path(name),
            content_length: byte_size(data),
            digest: Dahlia.Bill.Evidence.digest(data),
            user_id: user.id
          }
        ])
        |> Repo.insert!()

      data_mod = apply(evidence_mod, :data_mod, [])

      apply(data_mod, :new_changeset, [%{data: data, evidence_id: evidence.id}])
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

  def get_water_bill_summary_by_evidence_id(evidence_id) do
    Repo.get_by(WaterBillSummary, evidence_id: evidence_id)
  end

  def delete_water_bill_summary(%WaterBillSummary{} = summary) do
    Repo.delete(summary)
  end

  def get_water_bill_summary!(summary_id) do
    Repo.get!(WaterBillSummary, summary_id)
  end

  # Gas bill
  def save_gas_bill_evidence(%{} = attrs) do
    save_bill_evidence(GasBillEvidence, attrs)
  end

  def gas_bill_evidence_list(user) do
    query =
      from e in GasBillEvidence,
        where: e.user_id == ^user.id,
        order_by: {:desc, :inserted_at}

    Repo.all(query)
  end

  def get_gas_bill_evidence(id) do
    Repo.get(GasBillEvidence, id)
  end

  def get_gas_bill_evidence!(id) do
    Repo.get!(GasBillEvidence, id)
  end

  def get_gas_bill_evidence_data_by_evidence_id!(evidence_id) do
    Repo.get_by!(GasBillEvidenceData, evidence_id: evidence_id)
  end

  def delete_gas_bill_evidence(%GasBillEvidence{} = evidence) do
    Repo.delete(evidence)
  end

  def get_gas_bill_summary_by_evidence_id!(evidence_id) do
    Repo.get_by!(GasBillSummary, evidence_id: evidence_id)
  end

  def get_gas_bill_summary_by_evidence_id(evidence_id) do
    Repo.get_by(GasBillSummary, evidence_id: evidence_id)
  end

  def create_gas_summary(attrs \\ %{}) do
    %GasBillSummary{}
    |> GasBillSummary.changeset(attrs)
    |> Repo.insert()
  end

  def update_gas_summary(%GasBillSummary{} = summary, attrs \\ %{})do
    summary
    |> GasBillSummary.changeset(attrs)
    |> Repo.update()
  end

  def gas_bill_summary_list(user) do
    query =
      from s in GasBillSummary,
        join: e in GasBillEvidence,
        on: s.evidence_id == e.id,
        where: e.user_id == ^user.id,
        order_by: {:desc, s.read_date}

    Repo.all(query)
  end

  def delete_gas_bill_summary(%GasBillSummary{} = summary) do
    Repo.delete(summary)
  end
end
