defmodule Accent.Plug.Request do
  import Plug.Conn

  @doc false
  def init(opts \\ []) do
    %{
      transformer: opts[:transformer] || Accent.Transformer.SnakeCase
    }
  end

  @doc false
  def call(conn, opts) do
    case conn.params do
      %Plug.Conn.Unfetched{} -> conn
      _ -> %{conn | params: transform(conn.params, opts[:transformer])}
    end
  end

  # private

  defp transform(params, transformer) do
    for {k, v} <- params, into: %{} do
      key = transformer.call(k)

      if (is_map(v)) do
        {key, transformer.call(v)}
      else
        {key, v}
      end
    end
  end
end
