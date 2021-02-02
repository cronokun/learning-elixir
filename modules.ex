defmodule Times do
  def double(a) do
    a * 2
  end

  def triple(a) do
    a * 3
  end

  def quadruple(a) do
    double(double(a))
  end
end


defmodule Factorial do
  def of(0), do: 1
  def of(n), do: n * of(n - 1)
end


defmodule Test do
  def sum_first(0), do: 0
  def sum_first(1), do: 1
  def sum_first(n), do: n + sum_first(n - 1)

  def gcd(a, 0), do: a
  def gcd(a, b), do: gcd(b, rem(a, b))
end
