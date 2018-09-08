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

  def refresh(
    %{x: x, y: y, scroll_y: scroll_y, height: height} = window,
    content
  ) do
    Terminal.set_cursor(x, y)
    content
    |> Stream.drop(scroll_y)
    |> Stream.take(height)
    |> Stream.with_index()
    |> Enum.each(fn {r, i} -> print_row(window, r, i + y) end)
  end

  def print_row(%{x: x, scroll_x: scroll_x, width: width}, row, y) do
    Terminal.set_cursor(x, y)
    row
    |> Stream.drop(scroll_x)
    |> Stream.take(width)
    |> Enum.each(fn c -> Terminal.write(c) end)
    Terminal.clear_to_eol()
  end

  def change_cursor_x(
    %{width: width, scroll_x: scroll_x} = window,
    new_x,
    content_width
  ) do
    {new_cursor_x, new_scroll_x} =
      change_cursor_pos(width, scroll_x, new_x, content_width)
    %__MODULE__{window | cursor_x: new_cursor_x, scroll_x: new_scroll_x}
  end

  def change_cursor_y(
    %{height: height, scroll_y: scroll_y} = window,
    new_y,
    content_height
  ) do
    {new_cursor_y, new_scroll_y} =
      change_cursor_pos(height, scroll_y, new_y, content_height)
    %__MODULE__{window | cursor_y: new_cursor_y, scroll_y: new_scroll_y}
  end

  defp change_cursor_pos(window_size, scroll, new_value, content_size) do
    new_cursor = min(new_value, content_size - 1) - scroll
    cond do
      new_cursor < 0 ->
        {0, max(0, new_value)}
      new_cursor >= window_size ->
        {
          window_size - 1,
          min(content_size - window_size, new_value - window_size + 1)
        }
      true ->
        {new_cursor, scroll}
    end
  end
end
