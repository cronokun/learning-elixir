# List basics:
#
# [ head | tail ], where head is an list element, tails is a list (posibly empty):
#
# > [ 1 | [] ]      => [1]
# > [ 1 | [2, 3] ]  => [1, 2, 3]
#
# List concatenation: list1 ++ list2
#
# > [] ++ []            => []
# > [1] ++ []           => [1]
# > [1, 2] ++ [3, 4, 5] => [1, 2, 3, 4, 5]

defmodule MyList do
  def head([ head | _tail ]), do: head
  def tail([ _head | tail ]), do: tail
  def len([]), do: 0
  def len([ _head | tail ]), do: 1 + length(tail)

  def reverse([]), do: []
  def reverse([ head | tail ]) do
    reverse(tail) ++ [head]
  end

  def map([], _func), do: []
  def map([ head | tail ], func), do: [ func.(head) | map(tail, func) ]

  def reduce([], acc, _func), do: acc
  def reduce([ head | tail ], acc, func) do
    reduce(tail, func.(head, acc), func)
  end

  def filter(list , func) do
    reduce(list, [], fn x, acc -> if(func.(x), do: acc ++ [x], else: acc) end)
  end

  def reject(list, func) do
    reduce(list, [], fn x, acc -> if(!func.(x), do: acc ++ [x], else: acc) end)
  end

  def sum(list), do: reduce(list, 0, &(&1 + &2))

  def max([ head | tail ]) do
    reduce(tail, head, &(if &1 >= &2, do: &1, else: &2))
  end

  def min([ head | tail ]) do
    reduce(tail, head, &(if &1 <= &2, do: &1, else: &2))
  end

  def last(list), do: reduce(list, nil, fn x, _ -> x end)

  def all?(list, func), do: reduce(list, true, &(func.(&1) && &2))

  def take(list, n) do
    reduce(list, [], fn x, sublist -> if length(sublist) < n, do: sublist ++ [x], else: sublist end)
  end

  # split('abcdef', 4) => {'abcd', 'ef'}
  def split(list, position) do
    first = take(list, position)
    { first, list -- first }
  end

  # flatten([ 1, [ 2, 3, [4] ], 5, [[[6]]]]) => [1,2,3,4,5,6]
  def flatten(list) do
    reduce(list, [], fn x, acc -> if is_list(x), do: acc ++ flatten(x), else: acc ++ [x] end)
  end
end
