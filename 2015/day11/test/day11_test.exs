defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  describe "Tests the Day11.meets_first_requirement?/1 function" do
    test "abcdefgh" do
      assert Day11.meets_first_requirement?("abcdefgh") == true
    end

    test "abcdffaa" do
      assert Day11.meets_first_requirement?("abcdffaa") == true
    end

    test "ghijklmn" do
      assert Day11.meets_first_requirement?("ghijklmn") == true
    end

    test "ghjaabcc" do
      assert Day11.meets_first_requirement?("ghjaabcc") == true
    end

    test "hijklmmn" do
      assert Day11.meets_first_requirement?("hijklmmn") == true
    end

    test "abbceffg" do
      assert Day11.meets_first_requirement?("abbceffg") == false
    end

    test "abbcegjk" do
      assert Day11.meets_first_requirement?("abbcegjk") == false
    end
  end

  describe "Tests the Day11.meets_second_requirement?/1 function" do
    test "abcdefgh" do
      assert Day11.meets_second_requirement?("abcdefgh") == true
    end

    test "abcdffaa" do
      assert Day11.meets_second_requirement?("abcdffaa") == true
    end

    test "ghijklmn" do
      assert Day11.meets_second_requirement?("ghijklmn") == false
    end

    test "ghjaabcc" do
      assert Day11.meets_second_requirement?("ghjaabcc") == true
    end

    test "hijklmmn" do
      assert Day11.meets_second_requirement?("hijklmmn") == false
    end

    test "abbceffg" do
      assert Day11.meets_second_requirement?("abbceffg") == true
    end

    test "abbcegjk" do
      assert Day11.meets_second_requirement?("abbcegjk") == true
    end
  end

  describe "Tests the Day11.meets_third_requirement?/1 function" do
    test "abcdefgh" do
      assert Day11.meets_third_requirement?("abcdefgh") == false
    end

    test "abcdffaa" do
      assert Day11.meets_third_requirement?("abcdffaa") == true
    end

    test "ghijklmn" do
      assert Day11.meets_third_requirement?("ghijklmn") == false
    end

    test "ghjaabcc" do
      assert Day11.meets_third_requirement?("ghjaabcc") == true
    end

    test "hijklmmn" do
      assert Day11.meets_third_requirement?("hijklmmn") == false
    end

    test "abbceffg" do
      assert Day11.meets_third_requirement?("abbceffg") == true
    end

    test "abbcegjk" do
      assert Day11.meets_third_requirement?("abbcegjk") == false
    end
  end

  describe "Tests the Day11.valid_password?/1 function" do
    test "abcdefgh" do
      assert Day11.valid_password?("abcdefgh") == false
    end

    test "abcdffaa" do
      assert Day11.valid_password?("abcdffaa") == true
    end

    test "ghijklmn" do
      assert Day11.valid_password?("ghijklmn") == false
    end

    test "ghjaabcc" do
      assert Day11.valid_password?("ghjaabcc") == true
    end

    test "hijklmmn" do
      assert Day11.valid_password?("hijklmmn") == false
    end

    test "abbceffg" do
      assert Day11.valid_password?("abbceffg") == false
    end

    test "abbcegjk" do
      assert Day11.valid_password?("abbcegjk") == false
    end
  end

  describe "Tests the Day11.next_password/1 function" do
    test "abcdefgh" do
      assert Day11.next_password("abcdefgh") == "abcdefgi"
    end

    test "abcdffaa" do
      assert Day11.next_password("abcdffaa") == "abcdffab"
    end

    test "ghijklmn" do
      assert Day11.next_password("ghijklmn") == "ghjaaaaa"
    end

    test "ghjaabcz" do
      assert Day11.next_password("ghjaabcz") == "ghjaabda"
    end

    test "hijklmzz" do
      assert Day11.next_password("hijklmzz") == "hjaaaaaa"
    end

    test "abbceffg" do
      assert Day11.next_password("abbceffg") == "abbceffh"
    end

    test "abbcegjk" do
      assert Day11.next_password("abbcegjk") == "abbcegjl"
    end
  end

  describe "Tests the Day11.next_valid_password/1 function" do
    test "abcdefgh" do
      assert Day11.next_valid_password("abcdefgh") == "abcdffaa"
    end

    test "ghijklmn" do
      assert Day11.next_valid_password("ghijklmn") == "ghjaabcc"
    end
  end
end
