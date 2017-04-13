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
  def transform(%{} = map, transformer) do
    for {k, v} <- map, into: %{} do
      key = transformer.call(k)

      if is_map(v) || is_list(v) do
        {key, transform(v, transformer)}
      else
        {key, v}
      end
    end
  end

  @doc """
  Convert the keys of a list based on the provided transformer.
  """
  @spec transform(list, Accent.Transformer) :: list
  def transform(list, transformer) do
    for i <- list, into: [] do
      transform(i, transformer)
    end
  end
end
