defmodule Utils do
  # - Pega o ponto mais alto do grid
  def grid_highest_row(grid) do
    grid
    |> MapSet.to_list()
    |> List.keysort(0, :desc)
    |> hd()
    |> elem(0)
  end

end
