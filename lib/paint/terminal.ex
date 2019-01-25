defmodule Terminal do
  [
    :up,
    :down,
    :left,
    :right,
    :op,
    :background_color,
    :clear_to_eol
  ] |> Enum.each(fn name ->
    def unquote(name)(), do: apply(Tput, unquote(name), []) |> write
  end)

  def set_cursor(x, y), do: Tput.set_cursor(x, y) |> write()

  def clear_screen, do: write(IO.ANSI.clear)

  def write(str), do: IO.write(str)

  def cols do
    stty(["size"])
    |> String.split()
    |> List.last()
    |> String.to_integer()
  end

  def lines do
    stty(["size"])
    |> String.split()
    |> List.first()
    |> String.to_integer()
  end

  def run(f) do
    tty_original_settings = tty_settings()
    try do
      set_tty_settings(["raw", "-echo"])
      f.()
    after
      set_tty_settings([tty_original_settings])
    end
  end

  defp tty_settings, do: stty(["-g"])

  defp set_tty_settings(settings), do: stty(settings)

  defp stty(args) do
    tty = System.get_env("TTY")
    {result, 0} = System.cmd("stty", ["-F", tty | args])
    result
  end
end
