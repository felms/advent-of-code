defmodule Day04 do
  @moduledoc """
  Dia 04 do Advent of Code de 2015
  """

  def run(input) do
    generate_new_hash(input, 0)
  end

  defp generate_new_hash(input_string, number) do
    candidate_number = input_string <> Integer.to_string(number)

    generated_hash =
      :crypto.hash(:md5, candidate_number)
      |> Base.encode16()

    if generated_hash |> has_five_zeros?() do
      number
    else
      generate_new_hash(input_string, number + 1)
    end
  end

  defp has_five_zeros?(input_string), do: input_string |> String.starts_with?("00000")
end
