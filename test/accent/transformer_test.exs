defmodule Accent.TransformerTest do
  use ExUnit.Case

  describe "transform/2" do
    test "transforms the keys of a map" do
      assert Accent.Transformer.transform(%{"helloWorld" => "value"}, Accent.Transformer.SnakeCase)
        == %{"hello_world" => "value"}
    end

    test "transforms the keys of embedded maps" do
      assert Accent.Transformer.transform(%{"helloWorld" => %{"fooBar" => "value"}}, Accent.Transformer.SnakeCase)
        == %{"hello_world" => %{"foo_bar" => "value"}}
    end

    test "property handles arrays" do
      assert Accent.Transformer.transform(%{"helloWorld" => [%{"fooBar" => "value"}]}, Accent.Transformer.SnakeCase)
        == %{"hello_world" => [%{"foo_bar" => "value"}]}
      assert Accent.Transformer.transform(%{"helloWorld" => ["item"]}, Accent.Transformer.SnakeCase)
        == %{"hello_world" => ["item"]}
    end
  end
end
