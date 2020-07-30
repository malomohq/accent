defmodule Accent.Plug.ResponseTest do
  use ExUnit.Case
  use Plug.Test

  @default_opts [json_codec: Jason]

  @opts Accent.Plug.Response.init(json_codec: Jason)

  describe "init/1" do
    test "sets the \"default_case\" option to the value passed in" do
      opts = Accent.Plug.Response.init(@default_opts ++ [default_case: Accent.Case.Pascal])

      assert %{default_case: Accent.Case.Pascal} = opts
    end

    test "sets the \"header\" option to the value passed in" do
      opts = Accent.Plug.Response.init(@default_opts ++ [header: "x-accent"])

      assert %{header: "x-accent"} = opts
    end

    test "defaults the \"header\" option to \"accent\"" do
      opts = Accent.Plug.Response.init(@default_opts)

      assert %{header: "accent"} = opts
    end

    test "sets the \"json_codec\" option to the value passed in" do
      opts = Accent.Plug.Response.init(@default_opts)

      assert %{json_codec: Jason} = opts
    end

    test "raises ArgumentError if \"json_codec\" is not defined" do
      assert_raise ArgumentError, fn ->
        Accent.Plug.Response.init([])
      end
    end

    test "sets the \"supported_cases\" option to the value passed in" do
      opts =
        Accent.Plug.Response.init(
          @default_opts ++ [supported_cases: %{"test" => "some transformer"}]
        )

      assert %{supported_cases: %{"test" => "some transformer"}} = opts
    end

    test "defaults the \"supported_cases\" option" do
      opts = Accent.Plug.Response.init(@default_opts)

      assert %{
               supported_cases: %{
                 "camel" => Accent.Case.Camel,
                 "pascal" => Accent.Case.Pascal,
                 "snake" => Accent.Case.Snake
               }
             } = opts
    end
  end

  describe "call/2" do
    test "converts keys based on value passed to header" do
      conn =
        conn(:post, "/")
        |> put_req_header("accent", "pascal")
        |> put_resp_header("content-type", "application/json")
        |> Accent.Plug.Response.call(@opts)
        |> Plug.Conn.send_resp(200, "{\"hello_world\":\"value\"}")

      assert conn.resp_body == "{\"HelloWorld\":\"value\"}"
    end

    test "converts keys based on default case when no header is provided" do
      conn =
        conn(:post, "/")
        |> put_resp_header("content-type", "application/json")
        |> Accent.Plug.Response.call(Map.put(@opts, :default_case, Accent.Case.Camel))
        |> Plug.Conn.send_resp(200, "{\"hello_world\":\"value\"}")

      assert conn.resp_body == "{\"helloWorld\":\"value\"}"
    end

    test "deals with content-type having a charset" do
      conn =
        conn(:post, "/")
        |> put_req_header("accent", "pascal")
        |> put_resp_header("content-type", "application/json; charset=utf-8")
        |> Accent.Plug.Response.call(@opts)
        |> Plug.Conn.send_resp(200, "{\"hello_world\":\"value\"}")

      assert conn.resp_body == "{\"HelloWorld\":\"value\"}"
    end

    test "skips conversion if no header or default case is provided" do
      conn =
        conn(:post, "/")
        |> put_resp_header("content-type", "application/json")
        |> Accent.Plug.Response.call(@opts)
        |> Plug.Conn.send_resp(200, "{\"hello_world\":\"value\"}")

      assert conn.resp_body == "{\"hello_world\":\"value\"}"
    end

    test "skips conversion if content-type is not JSON" do
      conn =
        conn(:post, "/")
        |> put_req_header("accent", "pascal")
        |> put_resp_header("content-type", "text/html")
        |> Accent.Plug.Response.call(@opts)
        |> Plug.Conn.send_resp(200, "<p>This is not JSON, but it includes some hello_world</p>")

      assert conn.resp_body == "<p>This is not JSON, but it includes some hello_world</p>"
    end
  end
end
