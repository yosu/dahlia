defmodule Dahlia.Bill.WaterBillEvidenceData do
  @moduledoc false
  use Dahlia.Schema, prefix: "wbd_"
  import Ecto.Changeset

  schema "water_bill_evidence_data" do
    field :data, :binary

    has_one(:evidence, Dahlia.Bill.WaterBillEvidence, foreign_key: :data_id)

    timestamps(type: :utc_datetime_usec, updated_at: false)
  end

  def new_changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:data])
    |> validate_required([:data])
  end
end
