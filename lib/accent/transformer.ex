defmodule Accent.Transformer do
  @doc """
  Converts a string or atom to the same or different case.
  """
  @callback call(String.t | atom) :: String.t | atom

  @doc """
  Convert the keys of a map based on the provided transformer.

  If the value of
  a given key is a map then all keys of the embedded map will be converted as
  well.
  """
  @spec transform(map, Accent.Transformer) :: map
  def transform(input, transformer) do
    for {k, v} <- input, into: %{} do
      key = transformer.call(k)

      if (is_map(v)) do
        {key, transform(v, transformer)}
      else
        {key, v}
      end
    end
  end
end
