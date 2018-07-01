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

  def getch, do: IO.getn('', 1)

  # TODO: Get multiple chars when receiving \e.
  def get_key, do: getch()
  # def self.getkey
  #   c = [Terminal.getch]
  #   return c[0] if c[0] != ''
  #   loop do
  #     c << Timeout.timeout(0.1) { Terminal.getch }
  #   end
  # rescue Timeout::Error
  #   c.join
  # end

  def run(f) do
    tty_original_settings = tty_settings()
    try do
      set_tty_settings(["raw", "-echo"])
      f.()
    after
      set_tty_settings([tty_original_settings])
    end
  end

  # TODO: We can not get data from stty within an escript. Why?
  defp tty_settings do
    # {result, 0} = System.cmd("stty", ["-g"])
    # result
  end

  # TODO: We can not set data with stty within an escript. Why?
  defp set_tty_settings(_settings), do: nil # System.cmd("stty", settings)
end
