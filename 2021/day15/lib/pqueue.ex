defmodule PQueue do
  @moduledoc """
  Implementa uma Priority Queue baseada em uma Min Binary Heap.
  A Binary Heap foi implementada utitlizado a implementação de array
  mas como Elixir não tem arrays foi com lista mesmo.
  """

  defstruct heap: [], size: 0

  @doc """
  Retorna uma nove Priority Queue vazia
  """
  @spec new() :: {heap :: list(), size :: integer()}
  def new(), do: %PQueue{heap: [], size: 0}

  @doc """
  Retorna uma nove Priority Queue com os itens da lista fornecida
  """
  @spec new(input :: list()) :: {heap :: list(), size :: integer()}
  def new(input) do
    Enum.reduce(input, new(), fn item, queue ->
      insert(queue, item)
    end)
  end

  @doc """
  Consulta (sem remover) o elemento com menor valor/prioridade.
  """
  @spec peek({heap :: list(), size :: integer()}) :: tuple()
  def peek(queue), do: queue.heap |> hd()

  @doc """
  Testa se a Priority Queue está vazia.
  """
  @spec empty?({heap :: list(), size :: integer()}) :: boolean()
  def empty?(queue), do: queue.size == 0

  @doc """
  Inserção de novo elemento.
  """
  @spec insert({heap :: list(), size :: integer()}, tuple()) ::
          {heap :: list(), size :: integer()}
  def insert(queue, item) do
    %{queue | heap: insert_into_heap(queue.heap, item), size: queue.size + 1}
  end

  @doc """
  Remoção do elemento de menor valor/prioridade.
  """
  @spec poll({heap :: list(), size :: integer()}) ::
          {{heap :: list(), size :: integer()}, tuple()}
  def poll(%PQueue{size: 0}), do: PQueue.new()

  def poll(queue) do
    elem = queue.heap |> hd()

    updated_heap =
      queue.heap
      |> swap(0, -1)
      |> List.delete_at(-1)
      |> sink(0)

    {
      %{queue | heap: updated_heap, size: queue.size - 1},
      elem
    }
  end

  @doc """
  Diminuição da prioridade de um elemento.
  """
  @spec decrease_key({heap :: list(), size :: integer()}, tuple()) ::
          {{heap :: list(), size :: integer()}}
  def decrease_key(queue, item) do
    heap =
      queue.heap
      |> Enum.reject(&(elem(&1, 0) == elem(item, 0)))

    %{queue | heap: insert_into_heap(heap, item)}
  end

  # ======= Funções auxiliares para manipulação da Binary Heap

  defp insert_into_heap(heap, item) do
    heap
    |> List.insert_at(-1, item)
    |> swim(length(heap))
  end

  defp swim(heap, 0), do: heap
  defp swim(heap, _index) when length(heap) == 1, do: heap

  defp swim(heap, item_index) do
    parent_index = div(item_index - 1, 2)

    {_elem_coord, elem_priority} = Enum.at(heap, item_index)
    {_parent_coord, parent_priority} = Enum.at(heap, parent_index)

    if parent_priority <= elem_priority do
      heap
    else
      heap
      |> swap(item_index, parent_index)
      |> swim(parent_index)
    end
  end

  defp sink(heap, _index) when length(heap) == 1, do: heap

  defp sink(heap, index) do
    l = 2 * index + 1
    r = 2 * index + 2

    smallest =
      cond do
        l >= length(heap) ->
          index

        r >= length(heap) and Enum.at(heap, l) |> elem(1) < Enum.at(heap, index) |> elem(1) ->
          l

        r >= length(heap) and Enum.at(heap, l) |> elem(1) >= Enum.at(heap, index) |> elem(1) ->
          index

        true ->
          min_elem =
            Enum.min([
              Enum.at(heap, index) |> elem(1),
              Enum.at(heap, l) |> elem(1),
              Enum.at(heap, r) |> elem(1)
            ])

          cond do
            min_elem == Enum.at(heap, index) |> elem(1) -> index
            min_elem == Enum.at(heap, l) |> elem(1) -> l
            min_elem == Enum.at(heap, r) |> elem(1) -> r
          end
      end

    if smallest == index do
      heap
    else
      heap
      |> swap(index, smallest)
      |> sink(smallest)
    end
  end

  defp swap(heap, i, j) do
    elem_i = Enum.at(heap, i)
    elem_j = Enum.at(heap, j)

    heap
    |> List.replace_at(i, elem_j)
    |> List.replace_at(j, elem_i)
  end
end
