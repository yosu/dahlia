defmodule Dahlia.Bill.GasBillEvidence do
  @moduledoc false
  use Dahlia.Schema, prefix: "gbe_"
  import Ecto.Changeset

  schema "gas_bill_evidence" do
    field :name, :string
    field :content_type, :string
    field :content_length, :integer
    field :digest, :string

    belongs_to :user, Dahlia.Account.User
    has_one :data, Dahlia.Bill.GasBillEvidenceData, foreign_key: :evidence_id
    has_one :summary, Dahlia.Bill.GasBillSummary, foreign_key: :evidence_id

    timestamps(type: :utc_datetime_usec, updated_at: false)
  end

  @doc false
  def new_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :content_type, :content_length, :digest, :user_id])
    |> validate_required([:name, :content_type, :content_length, :digest, :user_id])
  end

  def data_mod do
    Dahlia.Bill.GasBillEvidenceData
  end
end
