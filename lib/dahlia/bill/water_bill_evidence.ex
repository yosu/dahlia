defmodule Dahlia.Bill.WaterBillEvidence do
  use Dahlia.Schema
  import Ecto.Changeset

  schema "water_bill_evidence" do
    field :name, :string
    field :content_type, :string
    field :content_length, :integer
    field :data, :binary
    field :digest, :string

    timestamps(type: :utc_datetime_usec, updated_at: false)
  end

  def new_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :content_type, :content_length, :data, :digest])
    |> validate_required([:name, :content_type, :content_length, :data, :digest])
  end
end
