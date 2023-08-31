defmodule CatFacts.BotConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, msg, _state}) do
    command =
      msg.content
      |> String.split(" ", parts: 2, trim: true)
      |> List.first

    case command do
      "!catfact" ->
        Api.create_message(msg.channel_id, "This will be a Cat Fact.")
      _ ->
        :ignore
    end
  end

  def handle_event({:READY, info, _state}) do
    command = %{
      name: "fact",
      description: "Add a cat fact.",
      default_member_permissions: 8, # admin
      options: [
        %{
          type: 3, # string
          name: "content",
          description: "Cat fact to be added.",
          required: true
        }
      ]
    }

    Enum.each(info.guilds, fn guild ->
      Api.bulk_overwrite_guild_application_commands(guild.id, [command])
    end)
  end

  def handle_event(_), do: :noop
end
