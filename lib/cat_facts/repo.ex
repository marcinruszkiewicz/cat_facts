defmodule CatFacts.Repo do
  use Ecto.Repo,
    otp_app: :cat_facts,
    adapter: Ecto.Adapters.Postgres
end
