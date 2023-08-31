import Config

config :cat_facts, CatFacts.Repo,
  database: "cat_facts_dev",
  username: "skyace",
  password: "",
  hostname: "localhost"

config :cat_facts, ecto_repos: [CatFacts.Repo]

config :nostrum,
  token: System.get_env("CATFACT_BOT_TOKEN"),
  gateway_intents: :all

config :logger, :console,
  metadata: [:shard, :guild, :channel]
