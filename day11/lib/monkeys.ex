defmodule Monkeys do

  # - Faz o parse do input e gera a estrutura de dados
  def parse_monkey(monkey) do
    [m_id, st_items, oper, test_div, test_true, test_false] = String.split(monkey, "\n", trim: true)

    monkey_id = String.replace(m_id, ~r/\D/, "") |> String.to_integer
    starting_items = Regex.scan(~r/\d+/, st_items) |> List.flatten |> Enum.map(fn item -> String.to_integer(item) end)
    operation = String.replace(oper, "Operation: new = ", "") |> String.split(" ", trim: true)

    div_by = Regex.run(~r/\d+/, test_div) |> hd |> String.to_integer
    if_true = Regex.run(~r/\d+/, test_true) |> hd |> String.to_integer
    if_false = Regex.run(~r/\d+/, test_false) |> hd |> String.to_integer

    monkey_test = %{:div_by => div_by, :if_true => if_true, :if_false => if_false}
    inspected_items = 0

    {monkey_id,
      %{:starting_items => starting_items,
        :operation => operation,
        :monkey_test => monkey_test,
        :inspected_items => inspected_items}
    }

  end

  # - Executa a rodada para o macaco e retorna o 'Map'
  # dos macacos atualizados
  def execute_round(monkeys, monkey_id) do

    monkey = Map.get(monkeys, monkey_id)

    inspected_items = monkey.inspected_items
    div_by = monkey.monkey_test.div_by
    if_true_monkey = monkey.monkey_test.if_true;
    if_false_monkey = monkey.monkey_test.if_false;
    operation = monkey.operation
    starting_items = monkey.starting_items


    {inspected, to_update} =
      starting_items
      |> Enum.reduce({inspected_items, %{if_true_monkey => [], if_false_monkey => []}},
        fn item, acc ->

          {insp, map} = acc
          new_value = apply_operation(operation, item) |> Integer.floor_div(3)
          new_inspected = insp + 1

          cond do
            rem(new_value, div_by) === 0 ->
              new_if_true_list = Map.get(map, if_true_monkey) |> List.insert_at(-1, new_value)
              new_map = Map.put(map, if_true_monkey, new_if_true_list)
              {new_inspected, new_map}
            true ->
              new_if_false_list = Map.get(map, if_false_monkey) |> List.insert_at(-1, new_value)
              new_map = Map.put(map, if_false_monkey, new_if_false_list)
              {new_inspected, new_map}
          end

        end)

    new_monkey = %{:inspected_items => inspected,
      :monkey_test => monkey.monkey_test,
      :operation => monkey.operation,
      :starting_items => []}


    old_if_true_monkey = Map.get(monkeys, if_true_monkey)
    old_if_false_monkey = Map.get(monkeys, if_false_monkey)

    if_true_monkey_items = old_if_true_monkey.starting_items
    if_false_monkey_items = old_if_false_monkey.starting_items

    new_itm_items = if_true_monkey_items ++ Map.get(to_update, if_true_monkey)
    new_if_true_monkey = Map.put(old_if_true_monkey, :starting_items, new_itm_items)

    new_ifm_items = if_false_monkey_items ++ Map.get(to_update, if_false_monkey)
    new_if_false_monkey = Map.put(old_if_false_monkey, :starting_items, new_ifm_items)

    Map.put(monkeys, monkey_id, new_monkey)
    |> Map.put(if_true_monkey, new_if_true_monkey)
    |> Map.put(if_false_monkey, new_if_false_monkey)

  end


  # - Executa a rodada para o macaco e retorna o 'Map'
  # dos macacos atualizado no caso onde o alivio é 1
  def execute_round_without_relief(monkeys, monkey_id) do

    monkey = Map.get(monkeys, monkey_id)

    inspected_items = monkey.inspected_items
    div_by = monkey.monkey_test.div_by
    if_true_monkey = monkey.monkey_test.if_true;
    if_false_monkey = monkey.monkey_test.if_false;
    operation = monkey.operation

    # Para manter os números dentro de uma faixa aceitável
    common_divisor = Enum.map(monkeys, fn {_k, value} -> value.monkey_test.div_by end)
    |> Enum.product
    starting_items = monkey.starting_items |> Enum.map(fn item -> rem(item, common_divisor) end)


    {inspected, to_update} =
      starting_items
      |> Enum.reduce({inspected_items, %{if_true_monkey => [], if_false_monkey => []}},
        fn item, acc ->

          {insp, map} = acc
          new_value = apply_operation(operation, item)
          new_inspected = insp + 1

          cond do
            rem(new_value, div_by) === 0 ->
              new_if_true_list = Map.get(map, if_true_monkey) |> List.insert_at(-1, new_value)
              new_map = Map.put(map, if_true_monkey, new_if_true_list)
              {new_inspected, new_map}
            true ->
              new_if_false_list = Map.get(map, if_false_monkey) |> List.insert_at(-1, new_value)
              new_map = Map.put(map, if_false_monkey, new_if_false_list)
              {new_inspected, new_map}
          end

        end)

    new_monkey = %{:inspected_items => inspected,
      :monkey_test => monkey.monkey_test,
      :operation => monkey.operation,
      :starting_items => []}


    old_if_true_monkey = Map.get(monkeys, if_true_monkey)
    old_if_false_monkey = Map.get(monkeys, if_false_monkey)

    if_true_monkey_items = old_if_true_monkey.starting_items

    if_false_monkey_items = old_if_false_monkey.starting_items

    new_itm_items = if_true_monkey_items ++ Map.get(to_update, if_true_monkey)
    new_if_true_monkey = Map.put(old_if_true_monkey, :starting_items, new_itm_items)

    new_ifm_items = if_false_monkey_items ++ Map.get(to_update, if_false_monkey)
    new_if_false_monkey = Map.put(old_if_false_monkey, :starting_items, new_ifm_items)

    Map.put(monkeys, monkey_id, new_monkey)
    |> Map.put(if_true_monkey, new_if_true_monkey)
    |> Map.put(if_false_monkey, new_if_false_monkey)

  end

  # - Aplica a operação sobre o item
  def apply_operation(operation, item) do

    [operand0, operation, operand1] = Enum.map(operation, fn value ->
      cond do
        value === "old" -> item
        String.match?(value, ~r/\d+/) -> String.to_integer(value)
        true -> value
      end
    end)

    cond do
      operation === "*" -> operand0 * operand1
      operation === "+" -> operand0 + operand1
    end

  end

end
