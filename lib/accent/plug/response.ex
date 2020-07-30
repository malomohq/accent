defmodule Accent.Plug.Response do
  @moduledoc """
  Transforms the keys of an HTTP response to the case requested by the client.

  A client can request what case the keys are formatted in by passing the case
  as a header in the request. By default the header key is `Accent`. If the
  client does not request a case or requests an unsupported case then a default
  case defined by `:default_case` will be used. If no default case is provided
  then no conversion will happen. By default the supported cases are `camel`,
  `pascal` and `snake`.

  ## Options

  * `:default_case` - module used to case the response when the client does not
    request a case or requests an unsupported case. When not provided then no
    conversation will happen for the above scenarios. Defaults to `nil`.
  * `:header` - the HTTP header used to determine the case to convert the
    response body to before sending the response (default: `Accent`)
  * `:json_codec` - module used to encode and decode JSON. The module is
    expected to define `decode/1` and `encode!/1` functions (required).
  * `:supported_cases` - map that defines what cases a client can request. By
    default `camel`, `pascal` and `snake` are supported.

  ## Examples

  ```
  plug Accent.Plug.Response, default_case: Accent.Case.Snake,
                             header: "x-accent",
                             supported_cases: %{"pascal" => Accent.Case.Pascal},
                             json_codec: Jason
  ```
  """

  import Plug.Conn

  @default_cases %{
    "camel" => Accent.Case.Camel,
    "pascal" => Accent.Case.Pascal,
    "snake" => Accent.Case.Snake
  }

  @doc false
  def init(opts \\ []) do
    %{
      default_case:
        opts[:default_case] ||
          nil,
      header:
        opts[:header] ||
          "accent",
      json_codec:
        opts[:json_codec] ||
          raise(ArgumentError, "Accent.Plug.Response expects a :json_codec option"),
      supported_cases:
        opts[:supported_cases] ||
          @default_cases
    }
  end

  @doc false
  def call(conn, opts) do
    register_before_send(conn, fn conn -> before_send_callback(conn, opts) end)
  end

  # private

  defp before_send_callback(conn, opts) do
    if do_call?(conn, opts) do
      response_content_type =
        conn
        |> get_resp_header("content-type")
        |> Enum.at(0)

      # Note - we don't support "+json" content types, and probably shouldn't add
      # as a general feature because they may have specifications for the param
      # names - e.g. https://tools.ietf.org/html/rfc7265#page-6 that mean the
      # translation would be inappropriate
      is_json_response = String.contains?(response_content_type || "", "application/json")

      if is_json_response do
        json_codec = opts[:json_codec]

        resp_body =
          conn.resp_body
          |> json_codec.decode!
          |> Accent.Case.convert(select_transformer(conn, opts))
          |> json_codec.encode!

        %{conn | resp_body: resp_body}
      else
        conn
      end
    else
      conn
    end
  end

  defp do_call?(conn, opts) do
    has_transformer = select_transformer(conn, opts)

    has_transformer
  end

  defp select_transformer(conn, opts) do
    accent = get_req_header(conn, opts[:header]) |> Enum.at(0)

    default_case = opts[:default_case]

    supported_cases = opts[:supported_cases]

    supported_cases[accent] || default_case
  end
end
