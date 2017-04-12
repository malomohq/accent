defmodule Accent.Plug.Request do
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
      _ -> %{conn | params: Accent.Transformer.transform(conn.params, opts[:transformer])}
    end
  end
end
