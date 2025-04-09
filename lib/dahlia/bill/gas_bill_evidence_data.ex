defmodule Dahlia.Bill.GasBillEvidenceData do
  @moduledoc false
  use Dahlia.Schema, prefix: "gbd_"
  import Ecto.Changeset

  schema "gas_bill_evidence_data" do
    field :data, :binary

    belongs_to :evidence, Dahlia.Bill.GasBillEvidence

    timestamps(type: :utc_datetime_usec, updated_at: false)
  end

  def new_changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:data, :evidence_id])
    |> validate_required([:data, :evidence_id])
  end
end
