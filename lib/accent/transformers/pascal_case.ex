defmodule Accent.Transformer.PascalCase do
  @moduledoc """
  Converts the given binary or atom to pascalCase format.
  """

  def call(atom) when is_atom(atom) do
    String.to_atom(call(to_string(atom)))
  end

  def call(<<?_, t::binary>>), do: call(t)

  def call(""), do: ""

  def call(<<h::utf8, t::binary>>) do
    String.Casing.downcase(<<h>>) <> do_pascalize(t)
  end

  # private

  defp do_pascalize(<<?_, ?_, t::binary>>) do
    do_pascalize(<<?_, t::binary>>)
  end

  defp do_pascalize(<<?_, h::utf8, t::binary>>) do
    String.Casing.upcase(<<h>>) <> do_pascalize(t)
  end

  defp do_pascalize(<<?_>>), do: <<>>

  defp do_pascalize(<<h::utf8, t::binary>>) do
    <<h>> <> do_pascalize(t)
  end

  defp do_pascalize(<<>>), do: <<>>
end
