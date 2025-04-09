defmodule Dahlia.Repo.Migrations.CreateGasBillEvidence do
  use Ecto.Migration

  def change do
    create table(:gas_bill_evidence) do
      add :name, :string, null: false
      add :content_type, :string, null: false
      add :content_length, :integer, null: false
      add :digest, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end

    create table(:gas_bill_evidence_data) do
      add :data, :binary, null: false
      add :evidence_id, references(:gas_bill_evidence, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end

    create index(:gas_bill_evidence, [:user_id])
    create unique_index(:gas_bill_evidence_data, :evidence_id)
  end
end
