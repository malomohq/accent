defmodule Accent.Transformer.SnakeCaseTest do
  use ExUnit.Case

  describe "call/1" do
    test "converts camelCase to snake_case" do
      assert Accent.Transformer.SnakeCase.call("helloWorld") == "hello_world"
    end

    test "converts CamelCase to snake_case" do
      assert Accent.Transformer.SnakeCase.call("HelloWorld") == "hello_world"
    end

    test "converts pascalCase to snake_case" do
      assert Accent.Transformer.SnakeCase.call("helloWorld") == "hello_world"
    end

    test "converts snake_case to snake_case" do
      assert Accent.Transformer.SnakeCase.call("hello_world") == "hello_world"
    end

    test "supports atom as an input" do
      assert Accent.Transformer.SnakeCase.call(:helloWorld) == :hello_world
    end
  end
end
