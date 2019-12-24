defmodule Accent.Mixfile do
  use Mix.Project

  def project do
    [
      app: :accent,
      name: "Accent",
      description: "Plug for converting JSON API keys to different cases",
      version: "0.2.1",
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test,
        "coveralls.travis": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [applications: [:logger, :plug]]
  end

  defp deps do
    [
      {:jason, "~> 1.0", optional: true},
      {:plug, "~> 1.3"},
      {:poison, ">= 3.1.0 and < 5.0.0", optional: true},
      # dev
      {:dialyxir, "~> 1.0.0-rc", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      # test
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "./_build/#{Mix.env()}"
    ]
  end

  defp package do
    %{
      maintainers: ["Anthony Smith"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/sticksnleaves/accent"
      }
    }
  end
end
