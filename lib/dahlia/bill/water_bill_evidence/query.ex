defmodule Dahlia.Bill.WaterBillEvidence.Query do
  @moduledoc """
  Query module for WaterBillEvidence.
  """
  import Ecto.Query

  alias Dahlia.Bill.WaterBillEvidence

  def order_by_inserted_at(queryable \\ WaterBillEvidence) do
    order_by(queryable, {:desc, :inserted_at})
  end
end
