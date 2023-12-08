defmodule Day08Test do
  use ExUnit.Case
  doctest Day08

  describe "tests Day08.execute_steps/4" do
    test "test sample input 1" do
      input_string =
        "RL\n\nAAA = (BBB, CCC)\nBBB = (DDD, EEE)\nCCC = (ZZZ, GGG)\nDDD = (DDD, DDD)\nEEE = (EEE, EEE)\nGGG = (GGG, GGG)\nZZZ = (ZZZ, ZZZ)"

      {instructions, grid} = Day08.parse_input(input_string)

      assert Day08.execute_steps(instructions, grid, "AAA", 0) == 2
    end

    test "test sample input 2" do
      input_string = "LLR\n\nAAA = (BBB, BBB)\nBBB = (AAA, ZZZ)\nZZZ = (ZZZ, ZZZ)"

      {instructions, grid} = Day08.parse_input(input_string)

      assert Day08.execute_steps(instructions, grid, "AAA", 0) == 6
    end
  end
end
