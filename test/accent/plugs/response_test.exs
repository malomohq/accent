defmodule Accent.Plug.ResponseTest do
  use ExUnit.Case
  use Plug.Test

  @default_opts [json_decoder: Poison, json_encoder: Poison]

  @opts Accent.Plug.Response.init([json_decoder: Poison, json_encoder: Poison])

  describe "init/1" do
    test "sets the \"header\" option to the value passed in" do
      opts = Accent.Plug.Response.init(@default_opts ++ [header: "x-accent"])

      assert %{header: "x-accent"} = opts
    end

    test "sets the \"default_case\" option to the value passed in" do
      opts = Accent.Plug.Response.init(@default_opts ++ [default_case: "pascal"])

      assert %{default_case: "pascal"} = opts
    end

    test "defaults the \"header\" option to \"accent\"" do
      opts = Accent.Plug.Response.init(@default_opts)

      assert %{header: "accent"} = opts
    end

    test "sets the \"json_decoder\" option to the value passed in" do
      opts = Accent.Plug.Response.init(@default_opts)

      assert %{json_decoder: Poison} = opts
    end

    test "raises ArgumentError if \"json_decoder\" is not defined" do
      assert_raise ArgumentError, fn ->
        Accent.Plug.Response.init([json_encoder: Poison])
      end
    end

    test "sets the \"json_encoder\" option to the value passed in" do
      opts = Accent.Plug.Response.init(@default_opts)

      assert %{json_encoder: Poison} = opts
    end

    test "raises ArgumentError if \"json_encoder\" is not defined" do
      assert_raise ArgumentError, fn ->
        Accent.Plug.Response.init([json_decoder: Poison])
      end
    end

    test "sets the \"supported_cases\" option to the value passed in" do
      opts = Accent.Plug.Response.init(@default_opts ++ [supported_cases: %{"test" => "some transformer"}])

      assert %{supported_cases: %{"test" => "some transformer"}} = opts
    end

    test "defaults the \"supported_cases\" option" do
      opts = Accent.Plug.Response.init(@default_opts)

      assert %{supported_cases: %{
        "camel" => Accent.Transformer.CamelCase,
        "pascal" => Accent.Transformer.PascalCase,
        "snake" => Accent.Transformer.SnakeCase
      }} = opts
    end
  end

  describe "call/2" do
    test "converts keys based on value passed to header" do
      conn =
        conn(:post, "/")
        |> put_req_header("accent", "pascal")
        |> put_req_header("content-type", "application/json")
        |> Accent.Plug.Response.call(@opts)
        |> Plug.Conn.send_resp(200, "{\"hello_world\":\"value\"}")

      assert conn.resp_body == "{\"helloWorld\":\"value\"}"
    end

    test "skips conversion if no header is provided" do
      conn =
        conn(:post, "/")
        |> put_req_header("content-type", "application/json")
        |> Accent.Plug.Response.call(@opts)
        |> Plug.Conn.send_resp(200, "{\"hello_world\":\"value\"}")

      assert conn.resp_body == "{\"hello_world\":\"value\"}"
    end

    test "skips conversion if content type is not JSON" do
      conn =
        conn(:post, "/")
        |> put_req_header("content-type", "application/something")
        |> Accent.Plug.Response.call(@opts)
        |> Plug.Conn.send_resp(200, "{\"hello_world\":\"value\"}")

      assert conn.resp_body == "{\"hello_world\":\"value\"}"
    end

    test "supports \"+json\" content types" do
      conn =
        conn(:post, "/")
        |> put_req_header("content-type", "application/something+json")
        |> Accent.Plug.Response.call(@opts)
        |> Plug.Conn.send_resp(200, "{\"hello_world\":\"value\"}")

      assert conn.resp_body == "{\"hello_world\":\"value\"}"
    end

    test "uses default case if specified" do
      opts = Accent.Plug.Response.init(@default_opts ++ [default_case: "pascal"])

      conn =
        conn(:post, "/")
        |> put_req_header("content-type", "application/something+json")
        |> Accent.Plug.Response.call(opts)
        |> Plug.Conn.send_resp(200, "{\"hello_world\":\"value\"}")

      assert conn.resp_body == "{\"helloWorld\":\"value\"}"
    end

    test "does not use default case if header is supplied" do
      opts = Accent.Plug.Response.init(@default_opts ++ [default_case: "pascal"])

      conn =
        conn(:post, "/")
        |> put_req_header("content-type", "application/something+json")
        |> put_req_header("accent", "snake")
        |> Accent.Plug.Response.call(opts)
        |> Plug.Conn.send_resp(200, "{\"hello_world\":\"value\"}")

      assert conn.resp_body == "{\"hello_world\":\"value\"}"
    end
  end
end
