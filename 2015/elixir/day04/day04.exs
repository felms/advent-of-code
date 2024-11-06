defmodule Day04 do
  @moduledoc """
  Dia 04 do Advent of Code de 2015
  """

  def run(input, part \\ :part01) do
    generate_new_hash(input, 0, part)
  end

  defp generate_new_hash(input_string, number, part) do
    candidate_number = input_string <> Integer.to_string(number)
    number_of_zeros = if part == :part01, do: 5, else: 6
    start_string = String.duplicate("0", number_of_zeros)

    generated_hash =
      :crypto.hash(:md5, candidate_number)
      |> Base.encode16()

    if generated_hash |> String.starts_with?(start_string) do
      number
    else
      generate_new_hash(input_string, number + 1, part)
    end
  end
end

# ---- Run

IO.puts("--- Part 01")
Day04.run("bgvyzdsv", :part01)
|> IO.puts

IO.puts("\n--- Part 02")
Day04.run("bgvyzdsv", :part02)
|> IO.puts
