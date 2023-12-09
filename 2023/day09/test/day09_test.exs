defmodule Day09Test do
  use ExUnit.Case
  doctest Day09

  describe "tests Day09.calc_differences_list/1" do
    test "tests [0, 3, 6, 9, 12, 15]" do
      assert Day09.calc_differences_list([[0, 3, 6, 9, 12, 15]]) == [
               [0, 3, 6, 9, 12, 15],
               [3, 3, 3, 3, 3],
               [0, 0, 0, 0]
             ]
    end

    test "tests [1, 3, 6, 10, 15, 21]" do
      assert Day09.calc_differences_list([[1, 3, 6, 10, 15, 21]]) == [
               [1, 3, 6, 10, 15, 21],
               [2, 3, 4, 5, 6],
               [1, 1, 1, 1],
               [0, 0, 0]
             ]
    end

    test "tests [10, 13, 16, 21, 30, 45, 68]" do
      assert Day09.calc_differences_list([[10, 13, 16, 21, 30, 45, 68]]) == [
               [10, 13, 16, 21, 30, 45, 68],
               [3, 3, 5, 9, 15, 23],
               [0, 2, 4, 6, 8],
               [2, 2, 2, 2],
               [0, 0, 0]
             ]
    end
  end

  describe "tests Day09.predict_next_value/1" do
    test "tests [0, 3, 6, 9, 12, 15]" do
      assert Day09.predict_next_value([0, 3, 6, 9, 12, 15]) == [0, 3, 6, 9, 12, 15, 18]
    end

    test "tests [1, 3, 6, 10, 15, 21]" do
      assert Day09.predict_next_value([1, 3, 6, 10, 15, 21]) == [1, 3, 6, 10, 15, 21, 28]
    end

    test "tests [10, 13, 16, 21, 30, 45, 68]" do
      assert Day09.predict_next_value([10, 13, 16, 21, 30, 45]) == [10, 13, 16, 21, 30, 45, 68]
    end
  end

  describe "tests Day09.predict_first_value/1" do
    test "tests [0, 3, 6, 9, 12, 15]" do
      assert Day09.predict_first_value([0, 3, 6, 9, 12, 15]) == [-3, 0, 3, 6, 9, 12, 15]
    end

    test "tests [1, 3, 6, 10, 15, 21]" do
      assert Day09.predict_first_value([1, 3, 6, 10, 15, 21]) == [0, 1, 3, 6, 10, 15, 21]
    end

    test "tests [10, 13, 16, 21, 30, 45, 68]" do
      assert Day09.predict_first_value([10, 13, 16, 21, 30, 45]) == [5, 10, 13, 16, 21, 30, 45]
    end
  end
end
