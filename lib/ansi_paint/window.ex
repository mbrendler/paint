defmodule Window do
  defstruct [
    x: 0,
    y: 0,
    width: 0,
    height: 0,
    scroll_x: 0,
    scroll_y: 0,
    cursor_x: 0,
    cursor_y: 0
  ]

  def new(x, y, width, height) do
    %__MODULE__{x: x, y: y, width: width, height: height}
  end

  def refresh(%{scroll_y: scroll_y, height: height} = window, content) do
    Terminal.set_cursor(0, 0)
    content
    |> Stream.drop(scroll_y)
    |> Stream.take(height)
    |> Stream.with_index()
    |> Enum.each(fn {r, i} -> print_row(window, r, i) end)
  end

  def print_row(%{scroll_x: scroll_x, width: width}, row, y) do
    Terminal.set_cursor(0, y)
    row
    |> Stream.drop(scroll_x)
    |> Stream.take(width)
    |> Enum.each(fn c -> Terminal.write(c) end)
  end

  def change_cursor_x(
    %{width: width, scroll_x: scroll_x} = window,
    new_x,
    content_width
  ) do
    new_cursor_x = new_x - scroll_x
    cond do
      new_cursor_x < 0 ->
        %__MODULE__{window | cursor_x: 0, scroll_x: max(0, new_x)}
      new_cursor_x >= width ->
        %__MODULE__{window |
          cursor_x: width - 1,
          scroll_x: min(content_width - width, new_x - width + 1)
        }
      true ->
        %__MODULE__{window | cursor_x: new_cursor_x}
    end
  end

  def change_cursor_y(
    %{height: height, scroll_y: scroll_y} = window,
    new_y,
    content_height
  ) do
    new_cursor_y = new_y - scroll_y
    cond do
      new_cursor_y < 0 ->
        %__MODULE__{window | cursor_y: 0, scroll_y: max(0, new_y)}
      new_cursor_y >= height ->
        %__MODULE__{window |
          cursor_y: height - 1,
          scroll_y: min(content_height - height, new_y - height + 1)
        }
      true ->
        %__MODULE__{window | cursor_y: new_cursor_y}
    end
  end
end
