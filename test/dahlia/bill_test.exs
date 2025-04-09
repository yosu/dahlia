defmodule Dahlia.BillTest do
  alias Dahlia.Bill.WaterBillEvidence
  alias Dahlia.Account
  alias Dahlia.Bill.WaterBillSummary
  use Dahlia.DataCase

  alias Dahlia.Bill
  alias Dahlia.Bill.WaterBillSummary

  import Dahlia.BillFixtures
  import Dahlia.AccountFixtures

  describe "water bill" do
    test "water_bill_evidence_list/1 returns all evidences" do
      user = user_fixture()
      evid = water_bill_evidence_fixture(%{user: user})

      assert Bill.water_bill_evidence_list(user) == [evid]
    end

    test "get_water_bill_evidence!/1 returns the evidence" do
      e = water_bill_evidence_fixture()

      assert Bill.get_water_bill_evidence!(e.id) == e
    end

    test "delete_water_bill_evidence/1 deletes a evidence" do
      e = water_bill_evidence_fixture()

      assert {:ok, e} = Bill.delete_water_bill_evidence(e)
      assert_raise Ecto.NoResultsError, fn -> Bill.get_water_bill_evidence!(e.id) end

      assert_raise Ecto.NoResultsError, fn ->
        Bill.get_water_bill_evidence_data_by_evidence_id!(e.id)
      end
    end

    test "outstanding_water_bill_evidence_list/0 returns the list of evidence which has no summary" do
      user = user_fixture()
      evidence = water_bill_evidence_fixture(%{user: user})
      _summary = water_bill_summary_fixture()

      assert Bill.outstanding_water_bill_evidence_list(user) == [evidence]
    end

    test "water_bill_summary_list/1 returns the list of summaries" do
      summary = water_bill_summary_fixture()
      evidence = Bill.get_water_bill_evidence!(summary.evidence_id)
      user = Account.get_user!(evidence.user_id)

      assert Bill.water_bill_summary_list(user) == [summary]
    end

    test "create_summary/1 with valid data create a summary" do
      e = water_bill_evidence_fixture()

      valid_attrs = %{
        bill_date: ~D[2025-04-02],
        due_date: ~D[2025-04-30],
        water_charge: 110,
        sewer_charge: 110,
        current_read: 10,
        current_read_date: ~D[2025-04-02],
        previous_read: 0,
        previous_read_date: ~D[2025-03-01],
        evidence_id: e.id
      }

      assert {:ok, %WaterBillSummary{} = summary} = Bill.create_summary(valid_attrs)
      assert summary.evidence_id == e.id
    end

    test "create_summary/1 with invalid data returns error changeset" do
      invalid_attrs = %{
        water_charge: -1
      }

      assert {:error, %Ecto.Changeset{}} = Bill.create_summary(invalid_attrs)
    end

    test "get_water_bill_summary_by_evidence_id!/1 with valid evidence id returns the summary" do
      summary = water_bill_summary_fixture()

      assert Bill.get_water_bill_summary_by_evidence_id!(summary.evidence_id) == summary
    end

    test "get_water_bill_summary_by_evidence_id/1 with valid evidence id returns the summary" do
      summary = water_bill_summary_fixture()

      assert ^summary = Bill.get_water_bill_summary_by_evidence_id(summary.evidence_id)
    end

    test "get_water_bill_summary_by_evidence_id/1 with invalid evidence id returns nil" do
      water_bill_summary_fixture()

      assert Bill.get_water_bill_summary_by_evidence_id("invalid") == nil
    end

    test "delete_water_bill_summary/1 deletes the summary" do
      summary = water_bill_summary_fixture()

      assert {:ok, %WaterBillSummary{}} = Bill.delete_water_bill_summary(summary)
      assert_raise Ecto.NoResultsError, fn -> Bill.get_water_bill_summary!(summary.id) end
      assert %WaterBillEvidence{} = Bill.get_water_bill_evidence!(summary.evidence_id)
    end
  end

  describe "gas_bill" do
    test "gas_bill_evidence_list/1 returns " do
      user = user_fixture()
      evidence = gas_bill_evidence_fixture(%{user: user})

      assert Bill.gas_bill_evidence_list(user) == [evidence]
    end
  end
end
