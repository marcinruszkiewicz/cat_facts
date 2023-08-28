import Config

config :nostrum,
  token: System.get_env("CATFACT_BOT_TOKEN"),
  gateway_intents: :all

config :logger, :console,
  metadata: [:shard, :guild, :channel]