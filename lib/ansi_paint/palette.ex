defmodule Palette do
  @esc ""

  @width 16
  @height div(256, @width)

  def new, do: Window.new(0, 0, @width, @height + 1)

  def content do
    op = Tput.op()
    (0..255)
    |> Enum.map(fn i -> "#{Tput.background_color(i)} #{op}" end)
    |> Enum.chunk_every(@width)
    |> Enum.concat([["                "]])
  end

  def run(palette) do
    Window.refresh(palette, content(), clear_to_eol: false)
    loop(palette)
  end

  def loop(%{cursor_x: cursor_x, cursor_y: cursor_y} = palette) do
    write_footer(palette)
    Terminal.set_cursor(cursor_x, cursor_y)
    case Stdin.get_key() do
      "h"  -> palette |> cursor_left() |> loop()
      "l"  -> palette |> cursor_right() |> loop()
      "j"  -> palette |> cursor_down() |> loop()
      "k"  -> palette |> cursor_up() |> loop()
      "\r" -> current_color(palette)
      " "  -> current_color(palette)
      "p"  -> current_color(palette)
      @esc -> nil
      "q"  -> nil
      _ -> loop(palette)
    end
  end

  def current_color(palette) do
    palette.cursor_x + palette.cursor_y * @width
  end

  def write_footer(palette) do
    color = current_color(palette)
    background = Tput.background_color(color)
    Terminal.set_cursor(0, @height)
    Terminal.write("#{background}   #{Tput.op()}")
    " #{color}"
    |> String.pad_trailing(@width - 4)
    |> Terminal.write()
  end

  def cursor_right(palette) do
    new_x = palette.scroll_x + palette.cursor_x + 1
    Window.change_cursor_x(palette, new_x, @width)
  end

  def cursor_left(palette) do
    new_x = palette.scroll_x + palette.cursor_x - 1
    Window.change_cursor_x(palette, new_x, @width)
  end

  def cursor_down(palette) do
    new_y = palette.scroll_y + palette.cursor_y + 1
    Window.change_cursor_y(palette, new_y, @height)
  end

  def cursor_up(palette) do
    new_y = palette.scroll_y + palette.cursor_y - 1
    Window.change_cursor_y(palette, new_y, @height)
  end
end
