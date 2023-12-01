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
end
