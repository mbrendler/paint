defmodule AnsiPaint do
  def main(args) do
    Tput.start_link()

    # TODO: handle arguments
    IO.inspect(args)

    image = load_image("../ansi-paint-rb/new.txt")
    state = State.new(Tput.cols, Tput.lines, image)
    Terminal.clear_screen()
    Window.refresh(state.main, image)
    Terminal.set_cursor(0, 0)
    Terminal.run(fn -> main_loop(state) end)
  end

  def main_loop(state) do
    Terminal.get_key()
    |> KeyMap.handle()
    |> Commands.run(state)
    |> main_loop()
  end

  def load_image(filename), do: filename |> File.stream!() |> Image.parse()
end
