defmodule Utils do
  # - Distancia entre dois pontos
  def manhattan_distance(point_a, point_b) do
    {x_1, y_1} = point_a
    {x_2, y_2} = point_b

    abs(x_1 - x_2) + abs(y_1 - y_2)
  end

  # - Gera os pontos da 'borda' da área visivél 
  # de um sensor
  def points_in_range({point_x, point_y}, radius) do
    left = {point_x - radius, point_y}

    upper_left =
      Enum.reduce_while(0..radius, [left], fn _, acc ->
        {x, y} = acc |> hd

        if x === point_x and y === point_y - radius do
          {:halt, acc}
        else
          new_acc = [{x + 1, y - 1} | acc]
          {:cont, new_acc}
        end
      end)

    upper_right =
      Enum.reduce_while(0..radius, upper_left, fn _, acc ->
        {x, y} = acc |> hd

        if x === point_x + radius and y === point_y do
          {:halt, acc}
        else
          new_acc = [{x + 1, y + 1} | acc]
          {:cont, new_acc}
        end
      end)

    lower_right =
      Enum.reduce_while(0..radius, upper_right, fn _, acc ->
        {x, y} = acc |> hd

        if x === point_x and y === point_y + radius do
          {:halt, acc}
        else
          new_acc = [{x - 1, y + 1} | acc]
          {:cont, new_acc}
        end
      end)

    Enum.reduce_while(0..radius, lower_right, fn _, acc ->
      {x, y} = acc |> hd

      if x === point_x - radius + 1 and y === point_y + 1 do
        {:halt, acc}
      else
        new_acc = [{x - 1, y - 1} | acc]
        {:cont, new_acc}
      end
    end)
  end
end
