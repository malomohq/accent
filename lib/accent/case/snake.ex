defmodule Accent.Case.Snake do
  @moduledoc """
  Converts the given binary or atom to `snake_case`.
  """

  @behaviour Accent.Case

  def call(atom) when is_atom(atom) do
    String.to_atom(call(to_string(atom)))
  end

  def call(""), do: ""

  def call(<<h::utf8, t::binary>>) do
    String.downcase(<<h>>) <> do_transform(t)
  end

  # private

  defp do_transform(<<h, t::binary>>) when h == ?_ do
    <<h>> <> do_transform(t)
  end

  defp do_transform(<<h, t::binary>>) do
    is_upper_case = String.upcase(<<h>>) == <<h>>

    if is_upper_case do
      "_" <> String.downcase(<<h>>) <> do_transform(t)
    else
      <<h>> <> do_transform(t)
    end
  end

  defp do_transform(<<>>), do: <<>>
end
