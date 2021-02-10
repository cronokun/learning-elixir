# Chapter 12: Control Flow

# FizzBuzz (different takes on the problem)
defmodule FizzBuzz do
  def upto(n) when n > 0, do: _upto(1, n, [])
  def upto_fixed(n) when n > 0, do: _downto(n, [])
  def upto_enum(n) when n > 0, do: 1..n |> Enum.map(&fizzbuzz/1)
  def upto_func(n) when n > 0, do: 1..n |> Enum.map(&fizzbuzz_func/1)
  def upto_case(n) when n > 0, do: 1..n |> Enum.map(&fizzbuzz_case/1)

  defp _upto(_current, 0, result), do: Enum.reverse(result)

  defp _upto(current, left, result) do
    next_answer = fizzbuzz(current)
    _upto(current + 1, left - 1, [next_answer | result])
  end


  defp _downto(0, result), do: result

  defp _downto(current, result) do
    next_answer = fizzbuzz(current)
    _downto(current - 1, [next_answer | result])
  end

  defp fizzbuzz(n) do
    cond do
      rem(n, 3) == 0 and rem(n, 5) == 0 ->
        "FizzBuzz"
      rem(n, 3) == 0 ->
        "Fizz"
      rem(n, 5) == 0 ->
        "Buzz"
      true ->
        n
    end
  end

  # Functional approach
  defp fizzbuzz_func(n), do: _fizzword(n, rem(n, 3), rem(n, 5))

  defp _fizzword(_n, 0, 0), do: "FizzBuzz"
  defp _fizzword(_n, 0, _), do: "Fizz"
  defp _fizzword(_n, _, 0), do: "Buzz"
  defp _fizzword(n, _, _), do: n

  # Functional with case
  defp fizzbuzz_case(n) do
    case {n, rem(n, 3), rem(n, 5)} do
      {_n, 0, 0} -> "FizzBuzz"
      {_n, 0, _} -> "Fizz"
      {_n, _, 0} -> "Buzz"
      {n, _, _} -> n
    end
  end
end


defmodule Foo do
  def open_file do
    case File.open("config_file") do
      {:ok, file} ->
        process(file)
      {:error, message} ->
        raise "Failed to open config file: #{message}"
    end
  end

  # Will raise an exeption on error:
  def open_file! do
    file = File.open!("config_file")
  end

  defp process(file) do
  end
end

defmodule Bar do
  def ok!(result) do
    case result do
      {:ok, data} -> data
      {:error, message} -> raise RuntimeError, message: "got error: #{message}"
    end
  end
end
