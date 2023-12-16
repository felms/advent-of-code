defmodule State do
  @moduledoc """
  Define o estado da aplicação e
  funções para manipular o mesmo.
  """

  defstruct [:execution_queue, :energized_tiles, :processed_beams]

  # - Cria um novo estado
  def new(execution_queue, energized_tiles \\ [], processed_beams \\ MapSet.new()) do
    %State{
      execution_queue: execution_queue,
      energized_tiles: energized_tiles,
      processed_beams: processed_beams
    }
  end
end
