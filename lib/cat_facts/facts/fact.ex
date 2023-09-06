defmodule CatFacts.Facts.Fact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "facts" do
    field :guild_id, :integer
    field :content, :string

    timestamps()
  end

  @doc false
  def changeset(config, attrs) do
    config
    |> cast(attrs, [:guild_id, :content])
    |> validate_required([:guild_id, :content])
  end
end
