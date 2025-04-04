defmodule Dahlia.Repo.Migrations.CreateWaterBillSummary do
  use Ecto.Migration

  def change do
    create table(:water_bill_summary, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :bill_date, :date, null: false
      add :due_date, :date, null: false
      add :total_charge, :integer, null: false
      add :total_charge_internal_tax, :integer, null: false
      add :water_charge, :integer, null: false
      add :water_charge_internal_tax, :integer, null: false
      add :sewer_charge, :integer, null: false
      add :sewer_charge_internal_tax, :integer, null: false
      add :current_read, :integer, null: false
      add :current_read_date, :date, null: false
      add :previous_read, :integer, null: false
      add :previous_read_date, :date, null: false
      add :evidence_id, references(:water_bill_evidence, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:water_bill_summary, [:evidence_id])
  end
end
