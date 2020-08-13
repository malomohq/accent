defmodule Accent.Case.SnakeTest do
  use ExUnit.Case

  describe "call/1" do
    test "converts camelCase to snake_case" do
      assert Accent.Case.Snake.call("helloWorld") == "hello_world"
    end

    test "converts PascalCase to snake_case" do
      assert Accent.Case.Snake.call("HelloWorld") == "hello_world"
    end

    test "converts snake_case to snake_case" do
      assert Accent.Case.Snake.call("hello_world") == "hello_world"
      assert Accent.Case.Snake.call("hello_world_1") == "hello_world_1"
    end

    test "supports atom as an input" do
      assert Accent.Case.Snake.call(:helloWorld) == :hello_world
    end
  end
end
