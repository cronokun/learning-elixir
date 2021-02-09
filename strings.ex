defmodule Parse do
  def number([ ?- | tail ]), do: _number_digits(tail, 0) * -1
  def number([ ?+ | tail ]), do: _number_digits(tail, 0)
  def number(str), do: _number_digits(str, 0)

  defp _number_digits([], value), do: value
  defp _number_digits([ digit | tail ], value)
  when digit in '0123456789' do
    _number_digits(tail, value * 10 + digit - ?0)
  end
  defp _number_digits([ digit | tail ], value)
  when digit in ',_' do
    _number_digits(tail, value)
  end
  defp _number_digits([ non_digit | _ ], _) do
    raise "Invalid digit '#{[non_digit]}'"
  end
end

defmodule MyString do
  def printable?([]), do: true
  def printable?([head | tail]) do
    head >= 32 && head <= ?~ && printable?(tail)
  end

  def anagram?(word1, word2) do
    Enum.sort(word1) === Enum.sort(word2)
  end

  def center(list) do
    max_length = Enum.map(list, &String.length/1) |> Enum.max
    Enum.map list, &(_center(&1, max_length)) |> IO.puts
  end

  defp _center(word, max_length) do
    word_length = String.length word
    pad_len = max_length - div(max_length - word_length, 2)
    String.pad_trailing(word, pad_len) |> String.pad_leading(max_length)
  end

  def capitalize_sentences(str) do
    String.split(str, ". ") |> Enum.map(&String.capitalize/1) |> Enum.join(". ")
  end
end

defmodule Calculator do
  def calculate(str) do
    str |> sanitize
        |> parse_expression
        |> calculate_expression
  end

  def sanitize(str) do
    Enum.filter str, fn ch -> ch in '0123456789+-*/' end
  end

  def parse_expression(str) do
    [number1, operand, number2] = Enum.chunk_by str, &(&1 in '+-*/')

    {
      _get_operation(operand),
      _parse_number(number1),
      _parse_number(number2)
    }
  end

  def calculate_expression({ op, number1, number2 }) do
    op.(number1, number2)
  end

  defp _get_operation(operand) do
    case operand do
      '+' -> &(&1 + &2)
      '-' -> &(&1 - &2)
      '*' -> &(&1 * &2)
      '/' -> &(&1 / &2)
    end
  end

  defp _parse_number([], value), do: value
  defp _parse_number([ digit | tail ], value \\ 0)
  when digit in '0123456789' do
    _parse_number(tail, value * 10 + digit - ?0)
  end
end
