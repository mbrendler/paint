defmodule Commands do
  def run(nil, state), do: state
  def run(name, state) do
    apply(__MODULE__, name, [state]) |> refresh_if_needed(state)
  end

  def cursor_left(%{main: main, image: image} = state) do
    new_x = main.scroll_x + main.cursor_x - 1
    new_window = Window.change_cursor_x(main, new_x, Image.width(image))
    %{state | main: new_window}
  end

  def cursor_down(%{main: main, image: image} = state) do
    new_y = main.scroll_y + main.cursor_y + 1
    new_window = Window.change_cursor_y(main, new_y, Image.height(image))
    %{state | main: new_window}
  end

  def cursor_up(%{main: main, image: image} = state) do
    new_y = main.scroll_y + main.cursor_y - 1
    new_window = Window.change_cursor_y(main, new_y, Image.height(image))
    %{state | main: new_window}
  end

  def cursor_right(%{main: main, image: image} = state) do
    new_x = main.scroll_x + main.cursor_x + 1
    new_window = Window.change_cursor_x(main, new_x, Image.width(image))
    %{state | main: new_window}
  end

  def start_of_line(%{main: main, image: image} = state) do
    new_window = Window.change_cursor_x(main, 0, Image.width(image))
    %{state | main: new_window}
  end

  def end_of_line(%{main: main, image: image} = state) do
    width = Image.width(image)
    new_window = Window.change_cursor_x(main, width - 1, width)
    %{state | main: new_window}
  end

  def top(%{main: main, image: image} = state) do
    new_window = Window.change_cursor_y(main, 0, Image.height(image))
    %{state | main: new_window}
  end

  def bottom(%{main: main, image: image} = state) do
    height = Image.height(image)
    new_window = Window.change_cursor_y(main, height - 1, height)
    %{state | main: new_window}
  end

  def refresh_if_needed(%{main: main} = state, %{main: old_main}) do
    should_refresh =
      main.scroll_x != old_main.scroll_x ||
      main.scroll_y != old_main.scroll_y

    if should_refresh, do: refresh(state), else: refresh_cursor(state)
  end

  def refresh(%{main: main, image: image} = state) do
    Window.refresh(main, image)
    refresh_cursor(state)
  end

  def refresh_cursor(%{main: main} = state) do
    Terminal.set_cursor(main.cursor_x, main.cursor_y)
    state
  end
end
