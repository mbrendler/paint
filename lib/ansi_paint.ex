defmodule AnsiPaint do
  def main(args) do
    Tput.start_link()
    Stdin.start()

    # TODO: handle arguments
    IO.inspect(args)

    filename = "../ansi-paint-rb/new.txt"
    image = load_image(filename)
    state = State.new(filename, Terminal.cols(), Terminal.lines(), image)
    Terminal.clear_screen()
    Window.refresh(state.main, image)
    State.refresh_status_line(state)
    Terminal.set_cursor(0, 0)
    Terminal.run(fn -> main_loop(state) end)
  end

  def main_loop(state) do
    Stdin.get_key()
    |> KeyMap.handle()
    |> Commands.run(state)
    |> main_loop()
  end

  def load_image(filename), do: filename |> File.stream!() |> Image.parse()
end
