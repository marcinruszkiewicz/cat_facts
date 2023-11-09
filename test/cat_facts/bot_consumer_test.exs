defmodule CatFacts.BotConsumerTest do
  use CatFacts.DataCase
  import CatFacts.Factory

  use Patch

  alias CatFacts.BotConsumer
  alias Nostrum.Struct.{WSState, Event, Guild, Interaction, Message}

  describe "on unhandled events" do
    setup do
      reaction_event = {:MESSAGE_REACTION_ADD, %Event.MessageReactionAdd{}, %WSState{}}

      {:ok, event: reaction_event}
    end

    test "handler returns noop", %{event: event} do
      assert BotConsumer.handle_event(event) == :noop
    end
  end

  describe "on READY event" do
    setup do
      guild = %Guild.UnavailableGuild{id: 1234, unavailable: true}
      ready = %Event.Ready{guilds: [guild]}
      ready_event = {:READY, ready, %WSState{}}
      expected_response = [
        %{
          name: "fact",
          options: [
            %{name: "content", type: 3, description: "Cat fact to be added.", required: true}
          ],
          description: "Add a cat fact.",
          default_member_permissions: 8
        }
      ]

      {:ok, event: ready_event, response: expected_response}
    end

    test "handler adds fact command to discord server", %{event: event, response: response} do
      patch(Nostrum.Api, :bulk_overwrite_guild_application_commands, nil)

      BotConsumer.handle_event(event)
      assert_called Nostrum.Api.bulk_overwrite_guild_application_commands(1234, ^response)
    end
  end

  describe "on INTERACTION event" do
    setup do
      interaction = %Interaction{
        guild_id: 12345,
        data: %{
          name: "fact",
          options: [
            %{name: "content", value: "very interesting fact"}
          ]
        }
      }
      interaction_event = {:INTERACTION_CREATE, interaction, %WSState{}}
      expected_response = %{
        data: %{
          flags: 64,
          content: "Your cat fact has been added to this server's list of cat facts."
        },
        type: 4
      }

      {:ok, event: interaction_event, response: expected_response, interaction: interaction}
    end

    test "handler adds a fact to database", %{event: event, response: response, interaction: interaction} do
      patch(Nostrum.Api, :create_interaction_response, nil)

      BotConsumer.handle_event(event)
      assert_called Nostrum.Api.create_interaction_response(^interaction, ^response)
    end
  end

  describe "on MESSAGE event" do
    setup do
      message = %Message{
        guild_id: 1234,
        channel_id: 456,
        content: "!catfact"
      }
      command_message_event = {:MESSAGE_CREATE, message, %WSState{}}

      bad_message = %Message{
        guild_id: 1234,
        channel_id: 456,
        content: "this should be ignored"
      }
      bad_message_event = {:MESSAGE_CREATE, bad_message, %WSState{}}

      {:ok, ok_event: command_message_event, bad_event: bad_message_event}
    end

    test "other message content is ignored", %{bad_event: event} do
      assert BotConsumer.handle_event(event) == :ignore
    end

    test "handles the !catfact command if there are no facts", %{ok_event: event} do
      patch(Nostrum.Api, :create_message, nil)

      BotConsumer.handle_event(event)
      assert_called Nostrum.Api.create_message(456, "I don't know any facts yet.")
    end

    test "handles the !catfact command with existing fact", %{ok_event: event} do
      insert(:fact, guild_id: 1234, content: "cool fact")
      patch(Nostrum.Api, :create_message, nil)

      BotConsumer.handle_event(event)
      assert_called Nostrum.Api.create_message(456, "cool fact")
    end
  end
end
