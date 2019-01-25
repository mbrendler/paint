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

  def width(image), do: image |> Enum.map(&length/1) |> Enum.max()

  def height(image), do: length(image)

  def get(image, x, y), do: image |> Enum.at(y) |> Enum.at(x)

  def set(image, x, y, value) do
    new_row =
      image
      |> Enum.at(y)
      |> List.replace_at(x, value <> Tput.op())
    List.replace_at(image, y, new_row)
  end

  def fill(image, x, y, new_color) do
    _fill(image, x, y, get(image, x, y), new_color)
  end

  defp _fill(image, x, y, old_color, new_color) do
    cond do
      x < 0 -> image
      y < 0 -> image
      x >= width(image) -> image
      y >= height(image) -> image
      new_color == get(image, x, y) -> image
      old_color != get(image, x, y) -> image
      true ->
        image
        |> set(x, y, new_color)
        |> _fill(x - 1, y - 1, old_color, new_color)
        |> _fill(x - 1, y, old_color, new_color)
        |> _fill(x - 1, y + 1, old_color, new_color)
        |> _fill(x, y - 1, old_color, new_color)
        |> _fill(x, y + 1, old_color, new_color)
        |> _fill(x + 1, y - 1, old_color, new_color)
        |> _fill(x + 1, y, old_color, new_color)
        |> _fill(x + 1, y + 1, old_color, new_color)
    end
  end
end
