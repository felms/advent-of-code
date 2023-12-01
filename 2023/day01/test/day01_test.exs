defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  describe "tests Day01.get_calibration_value/1" do
    test "tests 1abc2" do
      assert Day01.get_calibration_value("1abc2") == 12
    end

    test "tests pqr3stu8vwx" do
      assert Day01.get_calibration_value("pqr3stu8vwx") == 38
    end

    test "tests a1b2c3d4e5f" do
      assert Day01.get_calibration_value("a1b2c3d4e5f") == 15
    end

    test "tests treb7uchet" do
      assert Day01.get_calibration_value("treb7uchet") == 77
    end
  end

  describe "tests Day01.get_calibration_value_part_02/1" do
    test "tests two1nine" do
      assert Day01.get_calibration_value_part_02("two1nine") == 29
    end

    test "tests eightwothree" do
      assert Day01.get_calibration_value_part_02("eightwothree") == 83
    end

    test "tests abcone2threexyz" do
      assert Day01.get_calibration_value_part_02("abcone2threexyz") == 13
    end

    test "tests xtwone3four" do
      assert Day01.get_calibration_value_part_02("xtwone3four") == 24
    end

    test "tests 4nineeightseven2" do
      assert Day01.get_calibration_value_part_02("4nineeightseven2") == 42
    end

    test "tests zoneight234" do
      assert Day01.get_calibration_value_part_02("zoneight234") == 14
    end

    test "tests 7pqrstsixteen" do
      assert Day01.get_calibration_value_part_02("7pqrstsixteen") == 76
    end
  end
end
