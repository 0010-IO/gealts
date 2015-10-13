defmodule Gealts.Mixfile do
  use Mix.Project

  def project do
    [app: :gealts,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    []
  end

  defp package do
    [
      description: "A crude genetic programming library.",
      files: ["lib", "test", "mix.exs", "README.md", "LICENSE*"],
      maintainers: ["0010"],
      licenses: ["The Unlicense"],
      links: %{"GitHub" => "https://github.com/0010-IO/gealts",
               "0010" => "http://0010.io",
               "Original paper by Denny Hermawanto" => "http://arxiv.org/pdf/1308.4675.pdf"}
    ]
  end
end
