defmodule Issues.GithubIssues do
  require Logger

  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    Logger.info("Fetching #{user}'s project #{project}")

    issues_url(user, project)
    |> HTTPoison.get()
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({_, %{status_code: code, body: body}}) do
    Logger.info("Got response: status code=#{code}")
    Logger.debug(fn -> inspect(body) end)

    {
      check_for_error(code),
      Poison.Parser.parse!(body, %{})
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end
