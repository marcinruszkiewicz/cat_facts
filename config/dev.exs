import Config

config :cat_facts, CatFacts.Repo,
  database: "cat_facts_dev",
  username: "skyace",
  password: "",
  hostname: "localhost",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

