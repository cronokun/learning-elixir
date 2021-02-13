defmodule Stats do
  def sum(valuse), do: valuse |> Enum.reduce(0, &+/2)
  def count(values), do: values |> length
  def average(values), do: sum(values) / count(values)
end

ExUnit.start()

defmodule TestStats do
  use ExUnit.Case

  setup_all do
    IO.puts ">>> Start testing"
  end

  describe "Stats on list of ints" do
    setup context do
      if context[:sum] && context[:count] do
        [
          list: [1, 3, 5, 7, 9, 11],
          average: context[:sum] / context[:count]
        ]
      else
        [
          list: [1, 3, 5, 7, 9, 11],
        ]
      end
    end

    test "calculates sum", context do
      assert Stats.sum(context.list) == 36
    end

    test "calculates count", %{list: list} do
      assert Stats.count(list) == 6
    end

    @tag sum: 36, count: 6
    test "calculates average", %{list: list, average: expected_average} = _context do
      assert Stats.average(list) == expected_average
    end
  end
end
