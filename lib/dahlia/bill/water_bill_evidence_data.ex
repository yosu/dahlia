defmodule Dahlia.Bill.WaterBillEvidenceData do
  @moduledoc false
  use Dahlia.Schema, prefix: "wbd_"
  import Ecto.Changeset

  schema "water_bill_evidence_data" do
    field :data, :binary

    belongs_to(:evidence, Dahlia.Bill.WaterBillEvidence)

    timestamps(type: :utc_datetime_usec, updated_at: false)
  end

  def new_changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:data, :evidence_id])
    |> validate_required([:data, :evidence_id])
  end
end
