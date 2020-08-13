defmodule Accent.Helpers.Casing do
  @moduledoc false

  @spec lower?(binary) :: boolean
  def lower?(char) do
    char == String.downcase(char) && (String.upcase(char) != String.downcase(char))
  end

  @spec upper?(binary) :: boolean
  def upper?(char) do
    char == String.upcase(char) && (String.upcase(char) != String.downcase(char))
  end
end
