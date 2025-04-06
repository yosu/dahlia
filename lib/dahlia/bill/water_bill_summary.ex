defmodule Dahlia.Bill.WaterBillSummary do
  @moduledoc false
  use Dahlia.Schema
  import Ecto.Changeset

  schema "water_bill_summary" do
    field :bill_date, :date
    field :due_date, :date
    field :water_charge, :integer
    field :water_charge_internal_tax, :integer
    field :sewer_charge, :integer
    field :sewer_charge_internal_tax, :integer
    field :current_read, :integer
    field :current_read_date, :date
    field :previous_read, :integer
    field :previous_read_date, :date

    belongs_to(:evidence, Dahlia.Bill.WaterBillEvidence)

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(water_bill_summary, attrs) do
    water_bill_summary
    |> cast(attrs, [
      :bill_date,
      :due_date,
      :water_charge,
      :water_charge_internal_tax,
      :sewer_charge,
      :sewer_charge_internal_tax,
      :current_read,
      :current_read_date,
      :previous_read,
      :previous_read_date,
      :evidence_id
    ])
    |> validate_required([
      :bill_date,
      :due_date,
      :water_charge,
      :water_charge_internal_tax,
      :sewer_charge,
      :sewer_charge_internal_tax,
      :current_read,
      :current_read_date,
      :previous_read,
      :previous_read_date,
      :evidence_id
    ])
    |> validate_number(:water_charge, greater_than_or_equal_to: 0)
    |> validate_number(:water_charge_internal_tax, greater_than_or_equal_to: 0)
    |> validate_number(:sewer_charge, greater_than_or_equal_to: 0)
    |> validate_number(:sewer_charge_internal_tax, greater_than_or_equal_to: 0)
    |> validate_number(:current_read, greater_than_or_equal_to: 0)
    |> validate_number(:previous_read, greater_than_or_equal_to: 0)
  end

  def total_charge(summary = %__MODULE__{}) do
    summary.water_charge + summary.sewer_charge
  end
end
