# Chapter 8: Maps, Keyword Lists, Sets and Structs

#
## How to choose right data type:

# 1. Need patern-matching against the content?
#    > use a `map`
#
# 2. More than one entry with the same key?
#    > use the `Keayword` module
#
# 3. Need guaranty that the elements are ordered?
#    > use the `Keyword` module
#
# 4. Fixed set of fields?
#    > use a `struct`
#
# 5. Otherwise
#    > use a `map`


## Keyword Lists

defmodule Canvas do
  @defaults [ fg: "black", bg: "white", font: "Merriweather" ]

  def draw_text(text, options \\ []) do
    options = Keyword.merge(@defaults, options)

    IO.puts "Drawing text #{inspect(text)}"
    IO.puts "Foreground:  #{options[:fg]}"
    IO.puts "Background:  #{Keyword.get(options, :bg)}"
    IO.puts "Font:        #{Keyword.get(options, :font)}"
    IO.puts "Pattern:     #{Keyword.get(options, :pattern, "solid")}"
    IO.puts "Style:       #{inspect Keyword.get_values(options, :style)}"
  end
end

Canvas.draw_text("hello, world!", fg: "green", bg: "black", style: "bold", style: "mono")


## Maps

map = %{ name: "Crono", likes: "Ruby" }
Map.keys(map)                # => [:likes, :name]
Map.values(map)              # => ["Ruby", "Crono"]
map[:name]                   # => "Crono"
map.name                     # => "Crono"
map2 = Map.put(map, :also_likes, "Elixir")
anon = Map.drop(map, :name)
anon.has_key?(:name)         # => false
{ value, updated_map } = Map.pop(map2, :also_likes)
Map.equal?(map, updated_map) # => true


### Pattern-matching in Maps

person = %{name: "Crono", height: 182}

%{name: my_name} = person
my_name # => "Crono"

%{name: _, height: _} = person  # => a match
%{name: "Crono"} = person       # => a match
%{name: _, weight: _} = person  # => no match; raises error!


people = [
  %{ name: "Grumpy", height: 124 },
  %{ name: "Dave", height: 188 },
  %{ name: "Dopey", height: 132 },
  %{ name: "Shaquille", height: 216 },
  %{ name: "Sneezy", height: 128 }
]
IO.inspect(for person = %{ height: height } <- people, height > 150, do: person)


defmodule HotelRoom do
  def book(%{name: name, height: height})
  when height > 190 do
    IO.puts "Need extra-long bad for #{name}"
  end

  def book(%{name: name, height: height})
  when height < 130 do
    IO.puts "Need low shower controls for #{name}"
  end

  def book(%{name: name, height: height}) do
    IO.puts "Need regular bad for #{name}"
  end
end

people |> Enum.each(&HotelRoom.book/1)
# Enum.each(people, &HotelRoom.book/1)


### Updating the Map

# new_map = %{ old_map | key => value, ... }

map = %{ foo: 1, bar: 2, car: 3 }
map1 = %{ map | bar: 20, car: 30 }
map2 = %{ map1 | foo: 10 }
map3 = %{ map2 | baz: 666 } # can't add new key, will raise error!
map3 = Map.put_new(map2, :baz, 30)


## Structs

defmodule Subscriber do
  defstruct name: "", paid: false, over_18: true
end

s1 = %Subscriber{}
s2 = %Subscriber{name: "Crono"}
s3 = %Subscriber{name: "Mr. Rich", paid: true}
s4 = %Subscriber{s1 | name: "Anon"}


defmodule Attendee do
  defstruct name: "", paid: false, over_18: true

  def may_attend_after_party?(attendee = %Attendee{}) do
    attendee.paid && attendee.over_18
  end

  def print_vip_badge(%Attendee{name: name}) when name != "" do
    IO.puts "Very cheap badge for #{name}"
  end

  def print_vip_badge(%Attendee{}) do
    raise "missing name for badge"
  end
end

a1 = %Attendee{name: "Crono", over_18: true}
Attendee.may_attend_after_party?(a1)   # => false
a2 = %Attendee{a1 | paid: true}
Attendee.may_attend_after_party?(a1)   # => true
Attendee.print_vip_badge(a2)           # => "Very cheap badge for Crono"
Attendee.print_vip_badge(%Attendee{})  # => (RuntimeError) missing name for badge 


## Nested Dictionary Structures

defmodule Customer do
  defstruct name: "", company: ""
end

defmodule BugReport do
  defstruct owner: %Customer{}, details: "", severity: 1
end

report = %BugReport{
  owner: %Customer{name: "Crono", company: "n/a"},
  details: "something went wrong"
}
report.owner.company # => "n/a"
updated_report = put_in(report.owner.company, "Home LLC")
updated_report = update_in(updated_report.owner.name, &("Mr. #{&1}"))


## Sets

s1 = MapSet.new(1..5)
s2 = MapSet.new(3..8)
MapSet.memeber?(s1, 3)      # => true
MapSet.memeber?(s1, 9)      # => false
MapSet.union(s1, s2)        # => #MapSet<[1, 2, 3, 4, 5, 6, 7, 8]>
MapSet.difference(s1, s2)   # => #MapSet<[1, 2]>
MapSet.difference(s2, s1)   # => #MapSet<[6, 7, 8]>
MapSet.intersection(s1, s2) # => #MapSet<[3, 4, 5]>
