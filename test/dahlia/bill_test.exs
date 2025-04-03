defmodule Dahlia.BillTest do
  use Dahlia.DataCase

  alias Dahlia.Bill
  alias Dahlia.Bill.WaterBillEvidence

  import Dahlia.BillFixtures

  describe "water_bill_evidence_list/0" do
    test "returns all evidences" do
      evid = water_bill_evidence_fixture()

      assert Bill.water_bill_evidence_list() == [evid]
    end
  end

  describe "get_water_bill_evidence!/1" do
    test "returns the evidence" do
      e = water_bill_evidence_fixture()

      assert Bill.get_water_bill_evidence!(e.id) == e
    end
  end

  describe "delete_water_bill_evidence/1" do
    test "deletes a evidence" do
      e = water_bill_evidence_fixture()

      assert {:ok, %WaterBillEvidence{}} = Bill.delete_water_bill_evidence(e)
      assert_raise Ecto.NoResultsError, fn -> Bill.get_water_bill_evidence!(e.id) end
    end
  end
end
