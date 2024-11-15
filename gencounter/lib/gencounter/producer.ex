defmodule Gencounter.Producer do
  use GenStage

  # client
  def start_link(init \\ 0), do: GenStage.start_link(__MODULE__, init, name: __MODULE__)

  # server
  def init(counter), do: {:producer, counter}

  def handle_demand(demand, state) do
    event = Enum.to_list(state..state + demand - 1)
    {:noreply, event, state + demand}
  end
end
