defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  describe "tests execute_cycle" do
    test "one cycle" do
      input_file = "sample_input.txt"

      result_file = "result_01_cycle.txt"

      input =
        File.read!(input_file)
        |> String.replace("\r", "")
        |> Day14.parse_input()
        |> Day14.execute_cycle()

      result = File.read!(result_file) |> String.replace("\r", "") |> Day14.parse_input()

      assert input == result
    end

    test "two cycles" do
      input_file = "sample_input.txt"

      result_file = "result_02_cycles.txt"

      input =
        File.read!(input_file)
        |> String.replace("\r", "")
        |> Day14.parse_input()
        |> Day14.execute_cycles(2)

      result = File.read!(result_file) |> String.replace("\r", "") |> Day14.parse_input()

      assert input == result
    end

    test "three cycles" do
      input_file = "sample_input.txt"

      result_file = "result_03_cycles.txt"

      input =
        File.read!(input_file)
        |> String.replace("\r", "")
        |> Day14.parse_input()
        |> Day14.execute_cycles(3)

      result = File.read!(result_file) |> String.replace("\r", "") |> Day14.parse_input()

      assert input == result
    end
  end
end
