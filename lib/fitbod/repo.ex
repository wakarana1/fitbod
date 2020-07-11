defmodule FitbodApp.Repo do
  use Ecto.Repo,
    otp_app: :fitbod,
    adapter: Ecto.Adapters.Postgres
end
