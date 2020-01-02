defmodule Accent.Case.CamelTest do
  use ExUnit.Case

  describe "call/2" do
    test "converts snake_case to camelCase" do
      assert Accent.Case.Camel.call("hello_world") == "helloWorld"
    end

    test "trims leading and trailing underscores from input" do
      assert Accent.Case.Camel.call("_hello_world_") == "helloWorld"
    end

    test "supports atom as an input" do
      assert Accent.Case.Camel.call(:hello_world) == :helloWorld
    end

    test "properly handles multiple consecutive underscores" do
      assert Accent.Case.Camel.call("hello__world") == "helloWorld"
    end
  end
end
