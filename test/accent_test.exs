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

    test "supports :atom as an input" do
      assert Accent.camelize(:hello_world) == :helloWorld
    end
  end
end
