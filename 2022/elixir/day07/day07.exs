defmodule Day07 do
  @moduledoc """
  Dia 07 do Advent of Code 2022
  """

  # ======= Problema 01 - Soma dos diretorios com menos de 100000
  def sum_directories do

    # Calculando o tamanho de cada diretório e
    # fazendo a soma dos menores que 100000
    {_, tree} = parse_input()

    tree
    |> Enum.reduce(0, fn {key, _value}, sum ->
      size = sum_directory(tree, key)
      cond do
        size <= 100000 -> sum + size
        true -> sum

      end
    end)

  end

  # ======= Problema 02 - Deletar diretórios até ter espaço suficiente
  def delete_directories do

    # Calculando o tamanho de cada diretório
    # e montando a estrutura de dados
    {_, tree} = parse_input()

    total_space_fs = 70000000
    space_needed = 30000000

    directories_size = Enum.reduce(tree, %{}, fn {key, _value}, acc -> 
      Map.put(acc, key, sum_directory(tree, key))
    end)

    total_size = Map.get(directories_size, "/")
    unused_space = total_space_fs - total_size
    to_delete = space_needed - unused_space

    Enum.map(directories_size, fn {_, value} -> value end)
    |> Enum.filter(fn value -> value >= to_delete end)
    |> Enum.sort() |> hd

  end


  # ======= Utilitários
  
  # - Calcula o tamanho de um diretório
  # incluindo os subdiretórios
  defp sum_directory(tree, current_dir) do

    map = Map.get(tree, current_dir)
    files = Map.get(map, "files") 
    dirs = Map.get(map, "dirs")
           |> Enum.reduce(0, fn curr_dir, sum -> sum_directory(tree, curr_dir) + sum end)
    files + dirs
  end

  # - Faz o parse dos comandos e monta a árvore
  defp parse_input do

    # Limpando o input, fazendo o 'parse' dos comandos e gerando um mapa com os diretórios
    File.read!("./input.txt")
	|> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.split("\n",trim: true)
    |> Enum.reduce({nil, %{}}, fn command, acc -> 
      {path, map} = acc

      cond do
        command === "$ cd /" -> 
          new_path = "/"
          internal_map = Map.put(%{}, "dirs", []) |> Map.put("files", 0)
          new_map = Map.put(map, new_path, internal_map)
          {new_path, new_map}
        command === "$ cd .." ->
          new_path = String.split(path, "-") |> List.delete_at(-1) |> Enum.join("-")
          {new_path, map}
        String.contains?(command, "$ cd ") ->
          dir_name = String.replace(command, "$ cd ", "")
          new_path = path <> "-" <> dir_name
          internal_map = Map.put(%{}, "dirs", []) |> Map.put("files", 0)
          new_map = Map.put(map, new_path, internal_map)
          {new_path, new_map}
        command === "$ ls" -> acc
        String.contains?(command, "dir ") ->
          [ _prefix , dir_name] = String.split(command)
          dir_path = path <> "-" <> dir_name
          curr_internal_map = Map.get(map, path)
          new_dirs = [dir_path | Map.get(curr_internal_map, "dirs")]
          new_internal_map = Map.put(curr_internal_map, "dirs", new_dirs)
          new_map = Map.put(map, path, new_internal_map)
          {path, new_map}
        String.match?(command, ~r/\d+.*/) -> 
          [file_size, _] = String.split(command)
          curr_internal_map = Map.get(map, path)
          files = Map.get(curr_internal_map, "files") + String.to_integer(file_size)
          new_internal_map = Map.put(curr_internal_map, "files", files)
          new_map = Map.put(map, path, new_internal_map)
          {path, new_map}

      end
    end)

  end

end

# --- Run
IO.puts("Part 01")
Day07.sum_directories
|> IO.puts

IO.puts("\nPart 02")
Day07.delete_directories
|> IO.puts
