defmodule Accent.Plug.Request do
  @moduledoc """
  Transforms the keys of an HTTP request's params to the same or a different
  case.

  You can specify what case to convert keys to by passing in a `:transformer`
  option.

  Accent supports the following transformers out of the box:

  * `Accent.Transformer.CamelCase` (e.g. `CamelCase`)
  * `Accent.Transformer.PascalCase` (e.g. `pascalCase`)
  * `Accent.Transformer.SnakeCase` (e.g. `snake_case`)

  If no transformer is provided then `Accent.Transformer.SnakeCase` will be
  used.

  Please note that this plug will need to be executed after the request has
  been parsed.

  ## Example

  ```
  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json],
                     pass: ["*/*"],
                     json_decoder: Poison

  plug Accent.Plug.Request, transformer: Accent.Transformer.CamelCase
  ```
  """

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
