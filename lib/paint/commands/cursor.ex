defmodule Commands.Cursor do
  def left(%{main: main, image: image} = state, _) do
    new_x = main.scroll_x + main.cursor_x - 1
    new_window = Window.change_cursor_x(main, new_x, Image.width(image))
    %{state | main: new_window}
  end

  def down(%{main: main, image: image} = state, _) do
    new_y = main.scroll_y + main.cursor_y + 1
    new_window = Window.change_cursor_y(main, new_y, Image.height(image))
    %{state | main: new_window}
  end

  def up(%{main: main, image: image} = state, _) do
    new_y = main.scroll_y + main.cursor_y - 1
    new_window = Window.change_cursor_y(main, new_y, Image.height(image))
    %{state | main: new_window}
  end

  def right(%{main: main, image: image} = state, _) do
    new_x = main.scroll_x + main.cursor_x + 1
    new_window = Window.change_cursor_x(main, new_x, Image.width(image))
    %{state | main: new_window}
  end

  def start_of_line(%{main: main, image: image} = state, _) do
    new_window = Window.change_cursor_x(main, 0, Image.width(image))
    %{state | main: new_window}
  end

  def end_of_line(%{main: main, image: image} = state, _) do
    width = Image.width(image)
    new_window = Window.change_cursor_x(main, width - 1, width)
    %{state | main: new_window}
  end

  def top(%{main: main, image: image} = state, _) do
    new_window = Window.change_cursor_y(main, 0, Image.height(image))
    %{state | main: new_window}
  end

  def bottom(%{main: main, image: image} = state, _) do
    height = Image.height(image)
    new_window = Window.change_cursor_y(main, height - 1, height)
    %{state | main: new_window}
  end
end
