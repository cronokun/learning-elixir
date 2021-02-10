defmodule Issues.MixProject do
  use Mix.Project


  def project do
    [
      app: :issues,
      version: "0.1.0",
      name: "Issues",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:poison, "~> 4.0"},
      {:ex_doc, "~> 0.23"}
    ]
  end

  def escript do
    [
      main_module: Issues.CLI
    ]
  end
end