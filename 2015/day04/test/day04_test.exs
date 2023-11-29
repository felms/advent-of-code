defmodule Day04Test do
  use ExUnit.Case
  doctest Day04

  test "works with the first test input" do
    assert Day04.run("abcdef") == 609_043
  end

  test "works with the second test input" do
    assert Day04.run("pqrstuv") == 1_048_970
  end
end
