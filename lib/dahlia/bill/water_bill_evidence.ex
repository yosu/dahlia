defmodule Dahlia.Bill.WaterBillEvidence do
  @moduledoc false
  alias Dahlia.Bill.WaterBillEvidenceData
  use Dahlia.Schema, prefix: "wbe_"
  import Ecto.Changeset

  schema "water_bill_evidence" do
    field :name, :string
    field :content_type, :string
    field :content_length, :integer
    field :digest, :string

    belongs_to(:user, Dahlia.Account.User)
    has_one(:data, Dahlia.Bill.WaterBillEvidenceData, foreign_key: :evidence_id)
    has_one(:summary, Dahlia.Bill.WaterBillSummary, foreign_key: :evidence_id)

    timestamps(type: :utc_datetime_usec, updated_at: false)
  end

  def new_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :content_type, :content_length, :digest, :user_id])
    |> validate_required([:name, :content_type, :content_length, :digest, :user_id])
  end

  def data_mod do
    WaterBillEvidenceData
  end
end
