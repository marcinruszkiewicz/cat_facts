defmodule CatFacts.Factory do
  use ExMachina.Ecto, repo: CatFacts.Repo

  use CatFacts.FactFactory
end
