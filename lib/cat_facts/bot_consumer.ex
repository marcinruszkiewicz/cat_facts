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

  def handle_event({:READY, _event, _state}) do
    IO.puts "Cat Facts are Ready"
  end

  def handle_event(_), do: :noop
end
