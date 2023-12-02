defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  describe "tests Day02.parse_cube/2" do
    test "tests '3 blue, 4 red' searching red" do
      assert Day02.parse_cube("red", "3 blue, 4 red") == 4
    end

    test "tests '3 blue, 4 red' searching green" do
      assert Day02.parse_cube("green", "3 blue, 4 red") == 0
    end

    test "tests '3 blue, 4 red' searching blue" do
      assert Day02.parse_cube("blue", "3 blue, 4 red") == 3
    end

    test "tests '8 green, 6 blue, 20 red' searching red" do
      assert Day02.parse_cube("red", "8 green, 6 blue, 20 red") == 20
    end

    test "tests '8 green, 6 blue, 20 red' searching green" do
      assert Day02.parse_cube("green", "8 green, 6 blue, 20 red") == 8
    end

    test "tests '8 green, 6 blue, 20 red' searching blue" do
      assert Day02.parse_cube("blue", "8 green, 6 blue, 20 red") == 6
    end
  end

  describe "tests Day02.parse_handful/1" do
    test "tests '3 blue, 4 red'" do
      assert Day02.parse_handful("3 blue, 4 red") == %{red: 4, green: 0, blue: 3}
    end

    test "tests '8 green, 6 blue, 20 red'" do
      assert Day02.parse_handful("8 green, 6 blue, 20 red") == %{red: 20, green: 8, blue: 6}
    end

    test "tests '1 green, 3 red, 6 blue'" do
      assert Day02.parse_handful("1 green, 3 red, 6 blue") == %{red: 3, green: 1, blue: 6}
    end
  end

  describe "tests Day02.parse_game/1" do
    test "tests 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green'" do
      assert Day02.parse_game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green") ==
               %{
                 id: 1,
                 handfuls: [
                   %{red: 4, green: 0, blue: 3},
                   %{red: 1, green: 2, blue: 6},
                   %{red: 0, green: 2, blue: 0}
                 ]
               }
    end

    test "tests 'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red'" do
      assert Day02.parse_game(
               "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
             ) ==
               %{
                 id: 3,
                 handfuls: [
                   %{red: 20, green: 8, blue: 6},
                   %{red: 4, green: 13, blue: 5},
                   %{red: 1, green: 5, blue: 0}
                 ]
               }
    end

    test "tests 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green'" do
      assert Day02.parse_game("Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green") ==
               %{
                 id: 5,
                 handfuls: [
                   %{red: 6, green: 3, blue: 1},
                   %{red: 1, green: 2, blue: 2}
                 ]
               }
    end
  end

  describe "tests Day02.is_possible/1" do
    test "tests 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green'" do
      assert "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
             |> Day02.parse_game()
             |> Day02.is_possible()
    end

    test "tests 'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red'" do
      refute "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
             |> Day02.parse_game()
             |> Day02.is_possible()
    end

    test "tests 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green'" do
      assert "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
             |> Day02.parse_game()
             |> Day02.is_possible()
    end
  end
end
