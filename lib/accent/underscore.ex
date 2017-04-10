defmodule Accent.Underscore do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def underscore(atom) when is_atom(atom) do
        String.to_atom(underscore(to_string(atom)))
      end

      def underscore(""), do: ""

      def underscore(<<h::utf8, t::binary>>) do
        String.Casing.downcase(<<h>>) <> do_underscore(t)
      end

      defp do_underscore(<<h::utf8, t::binary>>) do
        is_upper_case = String.Casing.upcase(<<h>>) == <<h>>

        if is_upper_case do
          "_" <> String.Casing.downcase(<<h>>) <> do_underscore(t)
        else
          <<h>> <> do_underscore(t)
        end
      end

      defp do_underscore(<<>>), do: <<>>
    end
  end
end
