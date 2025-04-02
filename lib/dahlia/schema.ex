defmodule Dahlia.Schema do
  @moduledoc false
  defmacro __using__(opts) do
    quote do
      use Ecto.Schema

      unquote(primary_key(opts[:prefix]))
      @foreign_key_type ShortUUID
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end

  defp primary_key(prefix) when is_binary(prefix) do
    quote do
      @primary_key {:id, ShortUUID, autogenerate: true, prefix: unquote(prefix)}
    end
  end

  defp primary_key(_) do
    quote do
      @primary_key {:id, ShortUUID, autogenerate: true}
    end
  end
end
