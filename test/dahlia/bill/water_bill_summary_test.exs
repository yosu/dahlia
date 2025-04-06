defmodule Dahlia.Bill.WaterBillSummaryTest do
  use ExUnit.Case

  alias Dahlia.Bill.WaterBillSummary

  describe "water_bill_evidence" do
    test "total_charge/1 returns the total charge of the summary" do
      summary = %WaterBillSummary{
        water_charge: 110,
        sewer_charge: 220
      }

      assert WaterBillSummary.total_charge(summary) == 330
    end
  end
end
