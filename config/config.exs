import Config

config :cat_facts, ecto_repos: [CatFacts.Repo]

config :nostrum,
  token: System.get_env("CATFACT_BOT_TOKEN"),
  gateway_intents: :all

config :logger, :console,
  metadata: [:shard, :guild, :channel]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
