defmodule Paint do
  def main(args) do
    Tput.start_link()
    Stdin.start()

    {filename, image} = get_image(args)
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

  def get_image([]), do: {"new.txt", Image.new(10, 10)}
  def get_image([filename | _]), do: {filename, load_image(filename)}

  def load_image(filename), do: filename |> File.stream!() |> Image.parse()
end
