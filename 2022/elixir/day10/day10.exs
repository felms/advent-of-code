defmodule Day10 do
  @moduledoc """
  Dia 10 do Advent of Code 2022
  """

  # ======= Problema 01 - Soma da 'força do sinal'
  # em diferentes pontos
  def signal_strength_sum do

    {_, signal_strength} = File.read!("./input.txt")
	|> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.split("\n", trim: true)
    |> Enum.reduce({0, %{0 => 1}}, fn command, acc -> 

      {index, map} = acc
      previous = Map.get(map, index)

      cond do
        command === "noop" -> 
          new_index = index + 1
          {new_index, Map.put(map, new_index, previous)}
        String.match?(command, ~r/add/) -> 
          [_, number] = String.split(command)
          new_value = previous + String.to_integer(number)
          new_index = index + 1
          new_map = Map.put(map, new_index, previous) |> Map.put(new_index + 1, new_value)
          {new_index + 1, new_map}
      end

    end)

    twenty = Map.get(signal_strength, 19) * 20
    sixty = Map.get(signal_strength, 59) * 60
    hundred = Map.get(signal_strength, 99) * 100
    hundred_and_forty = Map.get(signal_strength, 139) * 140
    hundred_and_eigty = Map.get(signal_strength, 179) * 180
    two_hundred_and_twenty = Map.get(signal_strength, 219) * 220

    [twenty, sixty, hundred, hundred_and_forty, hundred_and_eigty, two_hundred_and_twenty]
    |> Enum.sum

  end

  # ======= Problema 02 - Letras desenhadas no CRT
  def update_display do

    # Posição inicial do sprite
    sprite_pos = [0, 1, 2]

    # Cria o estado inicial do CRT
    positions = for _n <- 0..239, do: [" . "] 
    positions = positions |> List.flatten

    #  Lê a aquivo de input e gera o estado 
    #  final do CRT 
    {_, crt, _} = File.read!("./input.txt")
	|> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.split("\n", trim: true)
    |> Enum.reduce({0, positions, sprite_pos}, fn command, acc -> 

      {cycle, crt_state, current_sprite_pos} = acc

      cond do
        command === "noop" -> 

          # Atualizo a tela antes do ciclo terminar e retorno o resultado
          new_crt_state = update_crt(cycle, crt_state, current_sprite_pos)
          new_cycle = cycle + 1
          {new_cycle, new_crt_state, current_sprite_pos}

        String.match?(command, ~r/add/) -> 

          # Atualizo a tela antes do primeiro ciclo
          n_crt_state = update_crt(cycle, crt_state, current_sprite_pos)
          new_cycle = cycle + 1

          # Atualizo a tela após o primeiro ciclo 
          new_crt_state = update_crt(new_cycle, n_crt_state, current_sprite_pos)
          current_cycle = new_cycle + 1
          
          # Atualizo a posição do sprite
          [_, number] = String.split(command)
          new_value = String.to_integer(number)
          new_sprite_pos = current_sprite_pos |> Enum.map(fn item -> item + new_value end)
          
          
          {current_cycle, new_crt_state, new_sprite_pos}
      end

    end)

    # Imprime o resultado na tela
    crt 
    |> Enum.chunk_every(40)
    |> Enum.map(fn chunk -> Enum.join(chunk, "") end)
    |> Enum.join("\n")
    |> IO.puts

  end

  # ======= Utilitários

  # - Atualiza o estado do crt
  defp update_crt(cycle, crt_state, sprite_pos) do 
    cycle_value = rem(cycle, 40)
    cond do
      Enum.member?(sprite_pos, cycle_value) -> 
        List.replace_at(crt_state, cycle, " # ")
      true -> crt_state
    end
  end

end

# --- Run
IO.puts("Part 01")
Day10.signal_strength_sum
|> IO.puts

IO.puts("\nPart 02")
Day10.update_display