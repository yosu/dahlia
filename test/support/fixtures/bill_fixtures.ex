defmodule Dahlia.BillFixtures do
  @moduledoc false
  alias Dahlia.Bill
  import Dahlia.AccountFixtures

  def unique_name, do: "name#{System.unique_integer()}"

  def valid_water_bill_evidence_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      name: unique_name(),
      data: "data",
      user: user_fixture()
    })
  end

  def water_bill_evidence_fixture(attrs \\ %{}) do
    {:ok, evidence} =
      attrs
      |> valid_water_bill_evidence_attributes()
      |> Bill.save_water_bill_evidence()

    evidence
  end
end
