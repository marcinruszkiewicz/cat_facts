defmodule CatFacts.FactFactory do
  alias CatFacts.Facts.Fact

  defmacro __using__(_opts) do
    quote do
      def fact_factory do
        %Fact{
          guild_id: 123,
          content: "a normal fact"
        }
      end
    end
  end
end
