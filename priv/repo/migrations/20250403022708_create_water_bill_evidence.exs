defmodule Dahlia.Repo.Migrations.CreateWaterBillEvidence do
  use Ecto.Migration

  def change do
    create table(:water_bill_evidence_data, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :data, :binary, null: false

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end

    create table(:water_bill_evidence, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :name, :string, null: false
      add :content_type, :string, null: false
      add :content_length, :integer, null: false

      add :data_id, references(:water_bill_evidence_data, type: :string, on_delete: :restrict),
        null: false

      add :digest, :string, null: false

      add :user_id, references(:users, type: :string, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end

    create unique_index(:water_bill_evidence, :data_id)
    create index(:water_bill_evidence, :user_id)
  end
end
