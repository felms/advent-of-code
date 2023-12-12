defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  describe "tests Day12.generate_damaged_spring_report/1" do
    test "tests #.#.###" do
      assert Day12.generate_damaged_spring_report("#.#.###") == "1,1,3"
    end

    test "tests .#...#....###." do
      assert Day12.generate_damaged_spring_report(".#...#....###.") == "1,1,3"
    end

    test "tests .#.###.#.######" do
      assert Day12.generate_damaged_spring_report(".#.###.#.######") == "1,3,1,6"
    end

    test "tests ####.#...#..." do
      assert Day12.generate_damaged_spring_report("####.#...#...") == "4,1,1"
    end

    test "tests #....######..#####." do
      assert Day12.generate_damaged_spring_report("#....######..#####.") == "1,6,5"
    end

    test "tests .###.##....#" do
      assert Day12.generate_damaged_spring_report(".###.##....#") == "3,2,1"
    end
  end
end
