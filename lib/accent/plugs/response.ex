defmodule Accent.Plug.Response do
  @moduledoc """
  Transforms the keys of an HTTP response to the case requested by the client.

  A client can request what case the keys are formatted in by passing the case
  as a header in the request. By default the header key is `Accent`. If the
  client does not request a case or requests an unsupported case then no
  conversion will happen. By default the supported cases are `camel`, `pascal`
  and `snake`.

  ## Options

  * `:header` - the HTTP header used to determine the case to convert the
    response body to before sending the response (default: `Accent`)
  * `:json_encoder` - module used to encode JSON. The module is expected to
    define a `encode!/1` function for encoding the response body as JSON.
    (required)
  * `:json_decoder` - module used to decode JSON. The module is expected to
    define a `decode!/1` function for decoding JSON into a map. (required)
  * `:supported_cases` - map that defines what cases a client can request. By
    default `camel`, `pascal` and `snake` are supported.

  ## Examples

  ```
  plug Accent.Plug.Response, header: "x-accent",
                             supported_cases: %{"pascal" => Accent.Transformer.PascalCase},
                             json_encoder: Poison,
                             json_decoder: Poison
  ```
  """

  import Plug.Conn
  import Accent.Transformer

  @default_cases %{
    "camel" => Accent.Transformer.CamelCase,
    "pascal" => Accent.Transformer.PascalCase,
    "snake" => Accent.Transformer.SnakeCase
  }

  @doc false
  def init(opts \\ []) do
    %{
      header: opts[:header] || "accent",
      default_case: opts[:default_case],
      json_decoder: opts[:json_decoder] || raise(ArgumentError, "Accent.Plug.Response expects a :json_decoder option"),
      json_encoder: opts[:json_encoder] || raise(ArgumentError, "Accent.Plug.Response expects a :json_encoder option"),
      supported_cases: opts[:supported_cases] || @default_cases
    }
  end

  @doc false
  def call(conn, opts) do
    if do_call?(conn, opts) do
      conn
      |> register_before_send(fn(conn) -> before_send_callback(conn, opts) end)
    else
      conn
    end
  end

  # private

  defp before_send_callback(conn, opts) do
    json_decoder = opts[:json_decoder]
    json_encoder = opts[:json_encoder]

    resp_body =
      conn.resp_body
      |> json_decoder.decode!
      |> transform(select_transformer(conn, opts))
      |> json_encoder.encode!

    %{conn | resp_body: resp_body}
  end

  defp do_call?(conn, opts) do
    is_json =
      conn
      |> get_req_header("content-type")
      |> Enum.at(0) || ""
      |> String.ends_with?("json")

    has_transformer = select_transformer(conn, opts)

    is_json && has_transformer
  end

  defp select_transformer(conn, opts) do
    accent = 
      case get_req_header(conn, opts[:header]) do
        [] -> opts[:default_case]
        [accent] -> accent
      end
    
    supported_cases = opts[:supported_cases]
    supported_cases[accent]
  end

end
