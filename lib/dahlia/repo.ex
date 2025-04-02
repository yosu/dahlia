defmodule Dahlia.Repo do
  use Ecto.Repo,
    otp_app: :dahlia,
    adapter: Ecto.Adapters.Postgres
end
