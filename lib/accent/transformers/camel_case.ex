defmodule Accent.Transformer.CamelCase do
  @moduledoc """
  Converts the given binary or atom to CamelCase format.
  """

  def call(atom) when is_atom(atom) do
    String.to_atom(call(to_string(atom)))
  end

  def call(<<?_, t::binary>>), do: call(t)

  def call(""), do: ""

  def call(<<h::utf8, t::binary>>) do
    String.Casing.upcase(<<h>>) <> do_camelize(t)
  end

  # private

  defp do_camelize(<<?_, ?_, t::binary>>) do
    do_camelize(<<?_, t::binary>>)
  end

  defp do_camelize(<<?_, h::utf8, t::binary>>) do
    String.Casing.upcase(<<h>>) <> do_camelize(t)
  end

  defp do_camelize(<<?_>>), do: <<>>

  defp do_camelize(<<h::utf8, t::binary>>) do
    <<h>> <> do_camelize(t)
  end

  defp do_camelize(<<>>), do: <<>>
end
