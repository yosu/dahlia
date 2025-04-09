defmodule Dahlia.Bill.Evidence do
  def digest(data) when is_binary(data) do
    :crypto.hash(:md5, data)
    |> Base.encode64()
    |> then(&("md5-" <> &1))
  end
end
