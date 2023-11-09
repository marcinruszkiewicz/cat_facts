defmodule CatFacts.Facts do
  import Ecto.Query, warn: false
  alias CatFacts.Repo

  alias CatFacts.Facts.Fact

  @doc """
  Returns a randomly chosen fact for the specified guild ID or nil if there aren't any facts present.

  ## Examples

      iex> get_random_guild_fact(99887)
      nil

      iex> create_guild_fact(123, "coolest fact")
      iex> create_guild_fact(543, "this one's uncool")
      iex> result = get_random_guild_fact(123)
      iex> result.content == "coolest fact"
      true
  """
  def get_random_guild_fact(guild_id) do
    query =
      from f in Fact,
      where: f.guild_id == ^guild_id,
      order_by: fragment("RANDOM()"),
      limit: 1

    Repo.one(query)
  end

  @doc """
  Creates a fact for the specified Discord guild with the supplied content.

  ## Examples

      iex> {:ok, %CatFacts.Facts.Fact{} = result} = create_guild_fact(12345, "my cool fact")
      iex> result.guild_id == 12345
      true

      iex> {:ok, %CatFacts.Facts.Fact{} = result} =
      ...>   create_guild_fact(12345, "my cool fact")
      iex> result.content == "my cool fact"
      true

  """
  def create_guild_fact(guild_id, content) do
    %Fact{}
    |> Fact.changeset(%{guild_id: guild_id, content: content})
    |> Repo.insert()
  end
end
