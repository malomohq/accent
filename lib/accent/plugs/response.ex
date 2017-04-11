defmodule Accent.Plug.Response do
  import Plug.Conn
  import Accent.Transformer

  @supported_transformers %{
    "camel" => Accent.Transformer.CamelCase,
    "pascal" => Accent.Transformer.PascalCase,
    "snake" => Accent.Transformer.SnakeCase
  }

  def init(opts \\ []) do
    %{
      header: opts[:header] || "accent",
      json_decoder: opts[:json_decoder] || raise(ArgumentError, "Accent.Plug.Response expects a :json_decoder option"),
      json_encoder: opts[:json_encoder] || raise(ArgumentError, "Accent.Plug.Response expects a :json_encoder option"),
      supported_transformers: opts[:supported_transformers] || @supported_transformers
    }
  end

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
    accent = get_req_header(conn, opts[:header]) |> Enum.at(0)
    supported_transformers = opts[:supported_transformers]

    supported_transformers[accent]
  end
end
