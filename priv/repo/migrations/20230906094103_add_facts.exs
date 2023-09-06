defmodule CatFacts.Repo.Migrations.AddFacts do
  use Ecto.Migration

  def change do
    create table(:facts) do
      add :guild_id, :bigint
      add :content, :text

      timestamps()
    end
  end
end
