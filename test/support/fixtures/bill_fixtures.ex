defmodule Dahlia.BillFixtures do
  alias Dahlia.Bill

  def unique_name, do: "name#{System.unique_integer()}.png"

  def valid_water_bill_evidence_attributes(attrs \\ %{}) do
    # https://stackoverflow.com/questions/1176022/unknown-file-type-mime
    content_type = "application/octed-stream"

    Enum.into(attrs, %{
      name: unique_name(),
      content_type: content_type,
      data: "data",
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
