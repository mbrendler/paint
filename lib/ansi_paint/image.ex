defmodule Image do
  def parse(stream) do
    stream
    |> Enum.map(&parse_line/1)
  end

  def parse_line(str) do
    str
    |> String.slice(0..-2)
    |> String.split(" ")
    |> Enum.map(&(&1 <> " "))
  end

  def get(image, x, y), do: image |> Enum.at(y) |> Enum.at(x)

  def set(image, x, y, value) do
    new_row =
      image
      |> Enum.at(y)
      |> List.replace_at(x, value)
    List.replace_at(image, y, new_row)
  end

  def width(image), do: image |> Enum.map(&length/1) |> Enum.max()

  def height(image), do: length(image)
end
