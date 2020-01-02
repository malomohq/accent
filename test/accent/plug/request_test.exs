defmodule Accent.Plug.RequestTest do
  use ExUnit.Case
  use Plug.Test

  @opts Accent.Plug.Request.init([])

  describe "init/1" do
    test "sets the \"case\" option to the value passed in" do
      assert Accent.Plug.Request.init(%{case: Accent.Case.Camel}) ==
               %{case: Accent.Case.Camel}
    end

    test "defaults the \"case\" option to Accent.Case.Snake" do
      assert Accent.Plug.Request.init(%{}) == %{case: Accent.Case.Snake}
    end
  end

  describe "call/2" do
    test "converts keys to snake_case by default" do
      conn =
        conn(:post, "/", %{"hello_world" => "value"})
        |> Accent.Plug.Request.call(@opts)

      assert conn.params == %{"hello_world" => "value"}
    end

    test "converts keys using provided case" do
      conn =
        conn(:post, "/", %{"hello_world" => "value"})
        |> Accent.Plug.Request.call(
          Accent.Plug.Request.init(case: Accent.Case.Camel)
        )

      assert conn.params == %{"helloWorld" => "value"}
    end

    test "properly handles POST requests" do
      conn =
        conn(:post, "/", "{\"helloWorld\": \"value\"}")
        |> put_req_header("content-type", "application/json")
        |> Plug.Parsers.call(Plug.Parsers.init(parsers: [:json], json_decoder: Jason))
        |> Accent.Plug.Request.call(@opts)

      assert conn.params == %{"hello_world" => "value"}
    end

    test "properly handles GET requests" do
      conn =
        conn(:get, "/?helloWorld=value")
        |> put_req_header("content-type", "application/json")
        |> Plug.Parsers.call(Plug.Parsers.init(parsers: [:json], json_decoder: Jason))
        |> Accent.Plug.Request.call(@opts)

      assert conn.params == %{"hello_world" => "value"}
    end
  end
end
