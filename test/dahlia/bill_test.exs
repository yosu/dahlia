defmodule Dahlia.BillTest do
  use Dahlia.DataCase

  alias Dahlia.Bill

  import Dahlia.BillFixtures

  describe "water_bill_evidence_list/0" do
    test "returns all evidences" do
      evid = water_bill_evidence_fixture()

      assert Bill.water_bill_evidence_list() == [evid]
    end
  end
end
