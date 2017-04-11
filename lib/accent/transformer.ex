defmodule Accent.Transformer do
  def transform(input, transformer) do
    for {k, v} <- input, into: %{} do
      key = transformer.call(k)

      if (is_map(v)) do
        {key, transformer.call(v)}
      else
        {key, v}
      end
    end
  end
end
