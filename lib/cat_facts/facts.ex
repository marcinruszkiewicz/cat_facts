defmodule CatFacts.Facts do
  import Ecto.Query, warn: false
  alias CatFacts.Repo

  alias CatFacts.Facts.Fact

  def get_random_guild_fact(guild_id) do
    query =
      from f in Fact,
      where: f.guild_id == ^guild_id,
      order_by: fragment("RANDOM()"),
      limit: 1

    Repo.one(query)
  end

  def create_guild_fact(guild_id, content) do
    %Fact{}
    |> Fact.changeset(%{guild_id: guild_id, content: content})
    |> Repo.insert()
  end
end
