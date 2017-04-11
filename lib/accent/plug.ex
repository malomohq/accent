defmodule Accent.Plug do
  import Plug.Conn

  @doc false
  def init(opts \\ []) do
    %{
      transformer: opts[:transformer] || Accent.Transformer.SnakeCase
    }
  end

  @doc false
  def call(conn, opts) do
    %{conn | params: transform(conn.params, opts[:transformer])}
  end

  # private

  defp transform(body, transformer) do
    for {k, v} <- body, into: %{} do
      key = transformer.call(k)

      if (is_map(v)) do
        {key, transformer.call(v)}
      else
        {key, v}
      end
    end
  end
end
