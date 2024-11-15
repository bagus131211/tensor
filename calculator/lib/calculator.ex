defmodule Calculator do
  def start, do: spawn(fn -> loop(0) end)

  defp loop(current_value) do
    new_value = receive do
      {:value, client_id} ->
        send(client_id, {:response, current_value})
        current_value

      {:add, value} -> current_value + value
      {:subtract, value} -> current_value - value
      {:multiply, value} -> current_value * value
      {:divide, value} -> div(current_value, value)

      invalid_request ->
        IO.puts("Invalid request #{inspect invalid_request}")
        current_value
    end
    loop(new_value)
  end

  def value(pid) do
    send(pid, {:value, self()})
    receive do
      {:response, value} -> value
    end
  end

  def add(pid, value) do
    send(pid, {:add, value})
    value pid
  end

  def subtract(pid, value) do
    send(pid, {:subtract, value})
    value pid
  end

  def multiply(pid, value) do
    send(pid, {:multiply, value})
    value pid
  end

  def divide(pid, value) do
    send(pid, {:divide, value})
    value pid
  end
end
