defmodule Commands.Paint do
  def pick(state, []), do: %{state | color: State.current_color(state)}
  def pick(state, [color_number]) do
    %{state | color: "#{Tput.background_color(color_number)} "}
  end

  def set(%{main: main, image: image, color: color, undo: undo} = state, _) do
    new_image = Image.set(image, main.cursor_x, main.cursor_y, color)
    %{state | image: new_image, undo: [state | undo], redo: []}
  end

  def set_and_next(state, args) do
    state |> set(args) |> Commands.Cursor.right([])
  end

  def fill(%{image: image, color: color, main: main, undo: undo} = state, _) do
    new_image = Image.fill(image, main.cursor_x, main.cursor_y, color)
    %{state | image: new_image, undo: [state | undo], redo: []}
  end
end
