defmodule Dahlia.BillFixtures do
  @moduledoc false
  alias Dahlia.Bill
  import Dahlia.AccountFixtures

  def unique_name, do: "name#{System.unique_integer()}"

  def valid_bill_evidence_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      name: unique_name(),
      data: "data",
      user: user_fixture()
    })
  end

  def valid_water_bill_summary_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      bill_date: ~D[2025-04-02],
      due_date: ~D[2025-04-30],
      water_charge: 110,
      sewer_charge: 110,
      current_read: 10,
      current_read_date: ~D[2025-04-02],
      previous_read: 0,
      previous_read_date: ~D[2025-03-01],
      evidence_id: water_bill_evidence_fixture().id
    })
  end

  def water_bill_evidence_fixture(attrs \\ %{}) do
    {:ok, evidence} =
      attrs
      |> valid_bill_evidence_attributes()
      |> Bill.save_water_bill_evidence()

    evidence
  end

  def gas_bill_evidence_fixture(attrs \\ %{}) do
    {:ok, evidence} =
      attrs
      |> valid_bill_evidence_attributes()
      |> Bill.save_gas_bill_evidence()

    evidence
  end

  def water_bill_summary_fixture(attrs \\ %{}) do
    {:ok, summary} =
      attrs
      |> valid_water_bill_summary_attributes()
      |> Bill.create_summary()

    summary
  end
end
