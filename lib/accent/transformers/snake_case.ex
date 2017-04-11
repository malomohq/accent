defmodule Accent.Transformer.SnakeCase do
  @moduledoc """
  Converts the given binary or atom to snake_case format.
  """

  def call(atom) when is_atom(atom) do
    String.to_atom(call(to_string(atom)))
  end

  def call(""), do: ""

  def call(<<h::utf8, t::binary>>) do
    String.Casing.downcase(<<h>>) <> do_underscore(t)
  end

  # private

  defp do_underscore(<<h, t::binary>>) when h == ?_ do
    <<h>> <> do_underscore(t)
  end

  defp do_underscore(<<h, t::binary>>) do
    is_upper_case = String.Casing.upcase(<<h>>) == <<h>>

    if is_upper_case do
      "_" <> String.Casing.downcase(<<h>>) <> do_underscore(t)
    else
      <<h>> <> do_underscore(t)
    end
  end

  defp do_underscore(<<>>), do: <<>>
end
