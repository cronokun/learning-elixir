defmodule Parallel do
  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end

result = Parallel.pmap 1..1000, &(&1 * &1)


Regex.run ~r{hello}i, "Hello, World!"


# Get user and group UIDs for _lp user from /etc/passwd file:
content = "Now is the time"

lp  =  with {:ok, file}   = File.open("/etc/passwd"),
            content       = IO.read(file, :all),  # note: same name as above
            :ok           = File.close(file),
            [_, uid, gid] = Regex.run(~r/^lp:.*?:(\d+):(\d+)/m, content)
       do
            "Group: #{gid}, User: #{uid}"
       end

IO.puts lp             #=> Group: 26, User: 26
IO.puts content        #=> Now is the time


# Alternative syntax:
lp =
  with {:ok, file} = File.open("/etc/passwd"),
       content = IO.read(file, :all),  # note: same name as above
       :ok = File.close(file),
       [_, uid, gid] <- Regex.run(~r/^crono:.*?:(\d+):(\d+)/m, content) do
    "Group: #{gid}, User: #{uid}"
  end

values = [1,2,3,4,5]
mean =
    with count = Enum.count(values),
         sum   = Enum.sum(values),
       do: sum/count


list_sum = fn
  [] -> 0
  [a, tail] -> a + list_sum(tail)
end


fizbuzz = fn
  0, 0, _ -> "FizBuzz"
  0, _, _ -> "Fiz"
  _, 0, _ -> "Buzz"
  _, _, a -> a
end

fizbuzz3 = fn
  n -> fizbuzz.(rem(n, 3), rem(n, 5), n)
end

sum2 =
  fn a ->
    fn b -> a + b
    end
  end

Enum.map [1,2,3,4,5], &(&1 * &1) # list of squares
