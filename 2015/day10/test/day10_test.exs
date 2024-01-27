defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  describe "Tests the Day10.step/1 function" do
    test "1" do
      assert Day10.step(1) == 11
    end

    test "11" do
      assert Day10.step(11) == 21
    end

    test "21" do
      assert Day10.step(21) == 1211
    end

    test "1211" do
      assert Day10.step(1211) == 111_221
    end

    test "111221" do
      assert Day10.step(111_221) == 312_211
    end
  end
end
