defmodule FitbodApp.Repo do
  use Ecto.Repo,
    otp_app: :fitbod,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Gets a record or returns not found.

  This is like `get`, but instead of returning a record or nil, it'll return {:ok, record} or {:error, :not_found}.
  This is similar to the difference between `Keyword.get/3` and `Keyword.fetch/2`.
  """
  def fetch(queryable, id, opts \\ []) do
    case get(queryable, id, opts) do
      nil ->
        {:error, :not_found}

      record ->
        {:ok, record}
    end
  end
end
