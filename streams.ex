# Chapter 10: Streams

# Gready / not lazy camputation:
1..10 |> Enum.map(&(&1 * &1)) |> Enum.with_index |> Enum.map(fn {n, i} -> n - i end)

# Better: no intermediate lists, only 7 elements processed
1..1_000_000
|> Stream.map(&(&1 * &1))
|> Stream.with_index
|> Stream.map(fn {n, i} -> n - i end)
|> Enum.take_while(&(&1 < 50))

# Longest word in dictionary => formaldehydesulphoxylate
IO.puts File.read!("/usr/share/dict/words") |> String.split |> Enum.max_by(&String.length/1)

# Better
IO.puts File.open!("/usr/share/dict/words")
|> IO.stream(:line)
|> Enum.max_by(&String.length/1)

# Even better (and faster!)
IO.puts File.stream!("/usr/share/dict/words") |> Enum.max_by(&String.length/1)



Stream.zip(1..100, Stream.cycle([:odd, :even])) |> Enum.take(10)

Stream.repeatedly(&:random.uniform/0) |> Enum.take(5)

Stream.iterate(2, &(&1 * &1)) |> Enum.take(5) # => [2, 4, 16, 256, 65536]


# Stream.unfold init_state, fn state -> { stream_value, new_state } end
#
# Fibonachi numbers:
#
# Init state: {0, 1}
# stream | state
#      0 | {1, 0+1}
#      1 | {1, 1+1}
#      1 | {2, 1+2}
#      2 | {3, 2+3}
#      3 | {5, 3+5}
#      5 | {8, 5+8}
#      .....
# => [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
Stream.unfold({0, 1}, fn {f1, f2} -> {f1, {f2, f1 + f2}} end) |> Enum.take(10)


# Read file line by line
Stream.resource(
  fn -> File.open!("sample") end,
  fn file ->
    case IO.read(file, :line) do
      data when is_binary(data) -> {[data], file}
      _ -> {:halt, file}
    end
  end,
  fn file -> File.close(file) end
)


defmodule Countdown do

  def sleep(seconds) do
    receive do
      after seconds*1000 -> nil
    end
  end

  def say(text) do
    spawn fn -> :os.cmd('say #{text}') end
  end

  def print(text) do
    IO.puts "#{text} second(s) left"
  end

  def timer do
    Stream.resource(
      fn -> # the number of seconds to the start of the next minute
         {_h, _m, s} = :erlang.time
         60 - s - 1
      end,

      fn # wait for the next second, then return its countdown
        0 ->
          {:halt, 0}

        count ->
          sleep(1)
          { [inspect(count)], count - 1 }
      end,

      fn _ -> nil end   # nothing to deallocate
    )
  end
end

counter = Countdown.timer
printer = counter |> Stream.each(&Countdown.print/1)
speaker = printer |> Stream.each(&Countdown.say/1)
IO.puts "5 seconds countdown"
speaker |> Enum.take(5)
IO.puts "Countdown for the end of minute"
speaker |> Enum.to_list
