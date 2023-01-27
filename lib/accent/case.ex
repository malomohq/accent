defmodule Accent.Case do
  @doc """
  Converts a string or atom to the same or different case.
  """
  @callback call(String.t() | atom) :: String.t() | atom

  @doc """
  Convert the keys of a map based on the provided transformer.

  If the value of a given key is a map then all keys of the embedded map will be
  converted as well.
  """
  @spec convert(map, module) :: map
  def convert(map, transformer) when is_map(map) do
    for {k, v} <- map, into: %{} do
      key = transformer.call(k)

      if is_map(v) || is_list(v) do
        {key, convert(v, transformer)}
      else
        {key, v}
      end
    end
  end
  
  @spec convert(list, module) :: list
  def convert(list, transformer) when is_list(list) do
    for i <- list, into: [] do
      if is_map(i) || is_list(i) do
        convert(i, transformer)
      else
        i
      end
    end
  end
end
