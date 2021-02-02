defmodule MyList do
  def len([]), do: 0
  def len([_head | tail]), do: 1 + len(tail)

  def square([]), do: []
  def square([head | tail]), do: [head * head | square(tail)]

  def map([], _func), do: []

  def map([head | tail], func) do
    [func.(head) | map(tail, func)]
  end

  def reduce([], value, _func), do: value

  def reduce([head | tail], value, func) do
    reduce(tail, func.(head, value), func)
  end

  def sum(list), do: reduce(list, 0, &(&1 + &2))

  def max([a]), do: a

  def max([head | tail]) do
    max_number(head, max(tail))
  end

  defp max_number(a, b) do
    if a >= b do
      a
    else
      b
    end
  end
end

# => [10,20,30,40,50]
MyList.map([1, 2, 3, 4, 5], fn n -> n * 10 end)
# => 120
MyList.reduce([1, 2, 3, 4, 5], 1, &(&1 * &2))


defmodule Swapper do
  def swap([]), do: []
  def swap([a]), do: [a]
  def swap([a, b | tail]), do: [b, a | swap(tail)]
end

defmodule WeatherHistory do
  def for_location([], _id), do: []
  def for_location([ head = [_, location_id, _, _] | tail], location_id) do
    [head | for_location(tail, location_id)]
  end
  def for_location([_ | tail], location_id), do: for_location(tail, location_id)

  def test_data do
    [
      [1366225622, 26, 15, 0.125],
      [1366225622, 27, 15, 0.45],
      [1366225622, 28, 21, 0.25],
      [1366229222, 26, 19, 0.081],
      [1366229222, 27, 17, 0.468],
      [1366229222, 28, 15, 0.60],
      [1366232822, 26, 22, 0.095],
      [1366232822, 27, 21, 0.05],
      [1366232822, 28, 24, 0.03],
      [1366236422, 26, 17, 0.025]
    ]
  end
end
