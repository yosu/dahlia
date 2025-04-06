defmodule Dahlia.Repo.Migrations.RemoveInternalTaxColumnsFromWaterBillSummary do
  use Ecto.Migration

  def change do
    alter table("water_bill_summary") do
      remove :water_charge_internal_tax
      remove :sewer_charge_internal_tax
    end
  end
end
