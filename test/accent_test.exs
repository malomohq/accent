defmodule AccentTest do
  use ExUnit.Case

  describe "camelize/2" do
    test "converts snake_case to camelCase by default" do
      assert Accent.camelize("hello_world") == "helloWorld"
    end

    test "converts snake_case to camelCase when :lower" do
      assert Accent.camelize("hello_world", :lower) == "helloWorld"
    end

    test "converts snake_case to CamelCase when :upper" do
      assert Accent.camelize("hello_world", :upper) == "HelloWorld"
    end

    test "trims leading and trailing underscores from input" do
      assert Accent.camelize("_hello_world_") == "helloWorld"
    end

    test "supports atom as an input" do
      assert Accent.camelize(:hello_world) == :helloWorld
    end
  end

  describe "underscore/1" do
    test "converts camelCase to snake_case" do
      assert Accent.underscore("helloWorld") == "hello_world"
    end

    test "converts CamelCase to snake_case" do
      assert Accent.underscore("HelloWorld") == "hello_world"
    end

    test "supports atom as an input" do
      assert Accent.underscore(:helloWorld) == :hello_world
    end
  end
end
