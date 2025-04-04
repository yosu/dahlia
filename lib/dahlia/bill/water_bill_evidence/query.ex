defmodule Dahlia.Bill.WaterBillEvidence.Query do
  @moduledoc """
  Query module for WaterBillEvidence.
  """
  import Ecto.Query

  alias Dahlia.Bill.WaterBillEvidence

  def order_by_inserted_at(queryable \\ WaterBillEvidence) do
    order_by(queryable, {:desc, :inserted_at})
  end

  def with_data() do
    from e in WaterBillEvidence,
      join: d in assoc(e, :data),
      preload: [data: d]
  end

  def with_user(queryable \\ WaterBillEvidence, user) do
    queryable
    |> where([e], e.user_id == ^user.id)

  end

  def by_id(queryable \\ WaterBillEvidence, id) do
    where(queryable, [e], e.id == ^id)
  end
end
