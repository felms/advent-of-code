defmodule Day15Test do
  use ExUnit.Case
  doctest Day15

  describe "tests Day15.get_hash/1" do
    test "rn=1" do
      assert Day15.get_hash("rn=1") == 30
    end

    test "cm-" do
      assert Day15.get_hash("cm-") == 253
    end

    test "qp=3" do
      assert Day15.get_hash("qp=3") == 97
    end

    test "cm=2" do
      assert Day15.get_hash("cm=2") == 47
    end

    test "qp-" do
      assert Day15.get_hash("qp-") == 14
    end

    test "pc=4" do
      assert Day15.get_hash("pc=4") == 180
    end

    test "ot=9" do
      assert Day15.get_hash("ot=9") == 9
    end

    test "ab=5" do
      assert Day15.get_hash("ab=5") == 197
    end

    test "pc-" do
      assert Day15.get_hash("pc-") == 48
    end

    test "pc=6" do
      assert Day15.get_hash("pc=6") == 214
    end

    test "ot=7" do
      assert Day15.get_hash("ot=7") == 231
    end
  end
end
