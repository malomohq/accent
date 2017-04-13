defmodule Accent.Mixfile do
  use Mix.Project

  def project do
    [
     app: :accent,
     name: "Accent",
     description: "Plug for converting JSON API keys to different cases",
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     preferred_cli_env: [
       "coveralls": :test,
       "coveralls.html": :test,
       "coveralls.travis": :test
     ],
     test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:plug, "~> 1.3.4"},
      # dev
      {:ex_doc, ">= 0.0.0", only: [:dev]},
      # test
      {:excoveralls, "~> 0.6.3", only: [:test]},
      {:poison, "~> 3.1.0", only: [:test]}
    ]
  end

  defp package do
    maintainers: ["Anthony Smith"],
    licenses: ["MIT"],
    links: %{
      GitHub: "https://github.com/sticksnleaves/accent"
    }
  end
end
