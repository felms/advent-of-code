defmodule Beam do
  @moduledoc """
  Define um Feixe de Luz e funções
  auxiliares para trabalhar com o mesmo.
  """

  defstruct [:position, :direction]

  # - Cria um novo Feixe de Luz
  def new(position, direction) do
    %Beam{
      position: position,
      direction: direction
    }
  end
end
