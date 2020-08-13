defmodule Accent.Helpers.CasingTest do
  use ExUnit.Case, async: true

  test "lower?/1" do
    assert Accent.Helpers.Casing.lower?("a")
    assert Accent.Helpers.Casing.lower?("ß")
    assert Accent.Helpers.Casing.lower?("ñ")

    refute Accent.Helpers.Casing.lower?("A")
    refute Accent.Helpers.Casing.lower?("Ñ")
    refute Accent.Helpers.Casing.lower?("1")
    refute Accent.Helpers.Casing.lower?(":")
  end

  test "upper?/1" do
    assert Accent.Helpers.Casing.upper?("A")
    assert Accent.Helpers.Casing.upper?("Ñ")

    refute Accent.Helpers.Casing.upper?("a")
    refute Accent.Helpers.Casing.upper?("ß")
    refute Accent.Helpers.Casing.upper?("ñ")
    refute Accent.Helpers.Casing.upper?("1")
    refute Accent.Helpers.Casing.upper?(":")
  end
end
