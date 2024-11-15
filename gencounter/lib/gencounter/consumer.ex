defmodule Gencounter.Consumer do
  use GenStage

  def start_link(init_arg \\ :state), do: GenStage.start_link(__MODULE__, init_arg)

  def init(state), do: {:consumer, state, subscribe_to: [Gencounter.ProducerConsumer]}

  def handle_events(events, _from, state) do
    for event <- events, do: IO.inspect({self(), event, state})
    {:noreply, [], state}
  end
end
