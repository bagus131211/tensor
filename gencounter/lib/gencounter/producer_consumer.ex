defmodule Gencounter.ProducerConsumer do
  require Integer
  use GenStage

  def start_link(init_arg \\ :state), do: GenStage.start_link(__MODULE__, init_arg, name: __MODULE__)

  def init(state), do: {:producer_consumer, state, subscribe_to: [Gencounter.Producer]}

  def handle_events(events, _from, state) do
    numbers = events |> Stream.filter(&Integer.is_even/1) |> Enum.to_list
    {:noreply, numbers, state}
  end
end
