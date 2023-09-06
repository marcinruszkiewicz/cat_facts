defmodule CatFacts.BotConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Nostrum.Struct.Interaction
  alias CatFacts.Facts

  def handle_event({:MESSAGE_CREATE, msg, _state}) do
    command =
      msg.content
      |> String.split(" ", parts: 2, trim: true)
      |> List.first

    case command do
      "!catfact" ->
        respond_with_catfact(msg)
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

  def handle_event({:INTERACTION_CREATE, %Interaction{guild_id: guild_id, data: %{name: "fact", options: [%{name: "content", value: content}]}} = interaction, _ws_state}) do
    Facts.create_guild_fact(guild_id, content)

    response = %{
      type: 4, # respond with a message
      data: %{
        content: "Your cat fact has been added to this server's list of cat facts.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  def handle_event(_), do: :noop

  defp respond_with_catfact(msg) do
    response =
      case Facts.get_random_guild_fact(msg.guild_id) do
        %CatFacts.Facts.Fact{content: content} ->
          content
        nil ->
          "I don't know any facts yet."
      end

    Api.create_message(msg.channel_id, response)
  end
end
