defmodule Dahlia.Repo.Migrations.CreateWaterBillEvidence do
  use Ecto.Migration

  def change do
    create table(:water_bill_evidence, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :name, :string, null: false
      add :content_type, :string, null: false
      add :content_length, :integer, null: false
      add :data, :binary, null: false
      add :digest, :string, null: false

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end
  end
end
