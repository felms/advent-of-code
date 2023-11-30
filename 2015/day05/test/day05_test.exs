defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  describe "Tests the Day05.contains_three_vowels?/1 function" do
    test "aei has at least three vowels" do
      assert Day05.contains_three_vowels?("aei")
    end

    test "xazegov has at least three vowels" do
      assert Day05.contains_three_vowels?("xazegov")
    end

    test "aeiouaeiouaeiou has at least three vowels" do
      assert Day05.contains_three_vowels?("aeiouaeiouaeiou")
    end

    test "ael doesn't have at least three vowels" do
      refute Day05.contains_three_vowels?("ael")
    end

    test "asfdasdfg doesn't hava least three vowels" do
      refute Day05.contains_three_vowels?("asfdasdfg")
    end

    test "bcdfghjklmnpqrstvwxz doesn't hava at least three vowels" do
      refute Day05.contains_three_vowels?("bcdfghjklmnpqrstvwxz")
    end
  end

  describe "Tests the Day05.contains_twice_in_a_row_letters?/1 function" do
    test "abcdde" do
      assert Day05.contains_twice_in_a_row_letters?("abcdde")
    end

    test "aabbccdd" do
      assert Day05.contains_twice_in_a_row_letters?("aabbccdd")
    end

    test "aeiouaeiouaeiou" do
      refute Day05.contains_twice_in_a_row_letters?("aeiouaeiouaeiou")
    end

    test "ael" do
      refute Day05.contains_twice_in_a_row_letters?("ael")
    end

    test "asfdasdfg" do
      refute Day05.contains_twice_in_a_row_letters?("asfdasdfg")
    end
  end

  describe "Tests the Day05.contains_disallowed_strings?/1 function" do
    test "abcdde" do
      assert Day05.contains_disallowed_strings?("abcdde")
    end

    test "bbccdd" do
      assert Day05.contains_disallowed_strings?("bbccdd")
    end

    test "opqrstuvwxyz" do
      assert Day05.contains_disallowed_strings?("opqrstuvwxyz")
    end

    test "opqrstuvz" do
      assert Day05.contains_disallowed_strings?("opqrstuvz")
    end

    test "xylocaina" do
      assert Day05.contains_disallowed_strings?("xylocaina")
    end

    test "ael" do
      refute Day05.contains_disallowed_strings?("ael")
    end

    test "asfdasdfg" do
      refute Day05.contains_disallowed_strings?("asfdasdfg")
    end
  end

  describe "Tests the Day05.is_nice?/1 function" do
    test "ugknbfddgicrmopn" do
      assert Day05.is_nice?("ugknbfddgicrmopn")
    end

    test "bbccdd" do
      assert Day05.contains_disallowed_strings?("bbccdd")
    end

    test "aaa" do
      assert Day05.is_nice?("aaa")
    end

    test "jchzalrnumimnmhp" do
      refute Day05.is_nice?("jchzalrnumimnmhp")
    end

    test "haegwjzuvuyypxyu" do
      refute Day05.is_nice?("haegwjzuvuyypxyu")
    end

    test "dvszwmarrgswjxmb" do
      refute Day05.is_nice?("dvszwmarrgswjxmb")
    end
  end
end
