defmodule Accent.Case.Camel do
  @moduledoc """
  Converts the given binary or atom to `camelCase`.
  """

  @behaviour Accent.Case

  def call(atom) when is_atom(atom) do
    String.to_atom(call(to_string(atom)))
  end

  def call(<<?_, t::binary>>), do: call(t)

  def call(""), do: ""

  def call(<<h::utf8, t::binary>>) do
    String.downcase(<<h>>) <> do_transform(t)
  end

  # private

  defp do_transform(<<?_, ?_, t::binary>>) do
    do_transform(<<?_, t::binary>>)
  end

  defp do_transform(<<?_, h::utf8, t::binary>>) do
    String.upcase(<<h>>) <> do_transform(t)
  end

  defp do_transform(<<?_>>), do: <<>>

  defp do_transform(<<h::utf8, t::binary>>) do
    <<h>> <> do_transform(t)
  end

  defp do_transform(<<>>), do: <<>>
end
