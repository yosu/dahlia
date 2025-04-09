defmodule Dahlia.Bill.GasBillSummary do
  @moduledoc false
  use Dahlia.Schema, prefix: "gbs_"
  import Ecto.Changeset

  schema "gas_bill_summary" do
    field :usage, :integer
    field :read_date, :date
    field :charge, :integer

    belongs_to :evidence, Dahlia.Bill.GasBillEvidence

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(gas_bill_summary, attrs \\ %{}) do
    gas_bill_summary
    |> cast(attrs, [:read_date, :charge, :usage, :evidence_id])
    |> validate_required([:read_date, :charge, :usage, :evidence_id])
    |> validate_number(:usage, greater_than_or_equal_to: 0)
    |> validate_number(:charge, greater_than_or_equal_to: 0)
  end
end
