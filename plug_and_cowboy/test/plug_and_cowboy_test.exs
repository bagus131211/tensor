defmodule PlugAndCowboyTest do
  use ExUnit.Case
  doctest PlugAndCowboy

  test "greets the world" do
    assert PlugAndCowboy.hello() == :world
  end
end
