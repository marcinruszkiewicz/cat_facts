import Config

config :cat_facts, CatFacts.Repo,
  username: "skyace",
  password: "",
  hostname: "localhost",
  database: "cat_facts_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :logger, level: :warning
