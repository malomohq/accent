defmodule Accent.Mixfile do
  use Mix.Project

  def project do
    [
      app: :accent,
      version: "1.1.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      { :jason, "~> 1.0", optional: true },
      { :plug,  "~> 1.3" },

      # dev

      { :dialyxir, "~> 1.0.0-rc", only: :dev, runtime: false },
      { :ex_doc,   ">= 0.0.0", only: :dev, runtime: false },
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "./_build/#{Mix.env()}"
    ]
  end

  defp package do
    %{
      description: "Dynamically convert the case of your JSON API keys",
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/malomohq/accent"
      }
    }
  end
end
