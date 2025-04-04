defmodule Dahlia.Bill.WaterBillEvidence do
  @moduledoc false
  use Dahlia.Schema, prefix: "wbe_"
  import Ecto.Changeset

  schema "water_bill_evidence" do
    field :name, :string
    field :content_type, :string
    field :content_length, :integer
    field :digest, :string

    belongs_to(:user, Dahlia.Account.User)
    belongs_to(:data, Dahlia.Bill.WaterBillEvidenceData)

    timestamps(type: :utc_datetime_usec, updated_at: false)
  end

  def new_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :content_type, :content_length, :data_id, :digest, :user_id])
    |> validate_required([:name, :content_type, :content_length, :data_id, :digest, :user_id])
  end
end
