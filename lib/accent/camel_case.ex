defmodule Accent.CamelCase do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def camelize(input, method \\ :lower)

      def camelize(atom, method) when is_atom(atom) do
        String.to_atom(camelize(to_string(atom), method))
      end

      def camelize("", _), do: ""

      def camelize(<<?_, t::binary>>, method), do: camelize(t, method)

      def camelize(<<h::utf8, t::binary>>, :lower) do
        String.Casing.downcase(<<h::utf8>>) <> do_camelize(t)
      end

      def camelize(<<h::utf8, t::binary>>, :upper) do
        String.Casing.upcase(<<h::utf8>>) <> do_camelize(t)
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
  end
end
