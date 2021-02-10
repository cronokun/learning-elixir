defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI,
    only: [parse_args: 1,
           sort_issues: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["-help", "anything"]) == :help
  end

  test "user, project and count returned if 3 values given" do
    assert parse_args(["cronokun", "mazes", "10"]) == {"cronokun", "mazes", 10}
  end

  test "user, project and default count returned if only 2 values given" do
    assert parse_args(["cronokun", "mazes"]) == {"cronokun", "mazes", 5}
  end

  test "sort descending orders the correct way" do
    result = sort_issues(fake_isses_list(["c", "a", "b", "d"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{d c b a}
  end

  defp fake_isses_list(values) do
    for value <- values, do: %{"created_at" => value, "foo" => "bar"}
  end
end
