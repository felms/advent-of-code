defmodule Day07 do
  @moduledoc """
  Dia 07 do Advent of Code 2022
  """

  # ======= Problema 01 - Soma dos diretorios com menos de 100000
  def sum_directories do

    #  !!!!!! ----- BUG -----
    # Diretórios com o mesmo nome e caminhos (path) diferentes

    # Limpando o input e gerando um mapa com os diretórios
    tree = File.read!("./input.txt")
    |> String.replace(~r/(\$\s)|(cd \.\.)|\r|ls/, "") # limpando o input
    |> String.split("cd",trim: true)
    |> Enum.map(fn item -> String.split(item, "\n", trim: true) end)
    |> Enum.reduce(%{}, fn [dir | items], acc -> Map.put(acc, String.trim_leading(dir), items) end)

    # Calculando o tamanho de cada diretório e
    # fazendo a soma dos menores que 100000
    tree
    |> Enum.reduce(0, fn {_key, value}, sum ->
      size = sum_directory(tree, value)
      cond do
        size <= 100000 -> sum + size
        true -> sum

      end
    end)

  end

  # - Calcula o tamanho de um diretório
  # incluindo os subdiretórios
  defp sum_directory(tree, current_dir) do
      Enum.reduce(current_dir, 0,fn item, sum ->
        [identifier, name] = String.split(item)
        IO.inspect(identifier)
        cond do
          String.match?(identifier, ~r/\d+/) -> sum + String.to_integer(identifier)
          true -> sum + sum_directory(tree, Map.get(tree, name))
        end
      end)
  end

end
