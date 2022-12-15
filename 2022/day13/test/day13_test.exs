defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  test "sort two equal lists" do
    assert Day13.sorter([], []) == :cont
    assert Day13.sorter([1,1,3,1,1], [1,1,3,1,1]) == :cont
    assert Day13.sorter([[1],[2,3,4]], [[1],[2,3,4]]) == :cont
    assert Day13.sorter([1,[2,[3,[4,[5,6,7]]]],8,9], [1,[2,[3,[4,[5,6,7]]]],8,9]) == :cont
  end

  test "sort two lists of the same size" do
    assert Day13.sorter([1,1,3,1,1], [1,1,5,1,1]) == true
  end

  test "sort tested lists" do
    assert Day13.sorter([[1],[2,3,4]], [[1],4]) == true
  end

  test "sort lists of different sizes and nesting levels" do
    assert Day13.sorter([9], [[8,7,6]]) == false
  end

  test "sort almost equal lists" do
    assert Day13.sorter([[4,4],4,4], [[4,4],4,4,4]) == true
    assert Day13.sorter([7,7,7,7], [7,7,7]) == false
  end

  test "sort non-empty vs empty list" do
    assert Day13.sorter([], [3]) == true
  end

  test "sort two nested empty lists" do
    assert Day13.sorter([[[]]], [[]]) == false
  end

  test "sort two deeply-nested empty lists" do
    assert Day13.sorter([1,[2,[3,[4,[5,6,7]]]],8,9], [1,[2,[3,[4,[5,6,0]]]],8,9]) == false
  end
end
