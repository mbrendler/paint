defmodule StatusLine do
  defstruct [
    window: nil,
    style: ""
  ]

  def new(y, width) do
    st = style()
    %__MODULE__{
      window: Window.new(0, y, width, 1),
      style: st
    }
  end

  def refresh(%{window: window, style: style}, content) do
    Window.refresh(window, [pretty_content(style, content)])
    Terminal.clear_to_eol()
  end

  defp pretty_content(style, content) do
    [style | Enum.intersperse(content, style)]
  end

  defp style do
    Tput.op <>
      Tput.bold <>
      Tput.italic <>
      Tput.background_color(25) <>
      Tput.foreground_color(231)
  end
end
