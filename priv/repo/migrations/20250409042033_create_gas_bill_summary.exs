defmodule Dahlia.Repo.Migrations.CreateGasBillSummary do
  use Ecto.Migration

  def change do
    create table(:gas_bill_summary) do
      add :read_date, :date, null: false
      add :charge, :integer, null: false
      add :usage, :integer, null: false
      add :evidence_id, references(:gas_bill_evidence), null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:gas_bill_summary, :evidence_id)
  end
end
