defmodule KeyMap do
  def handle(key) do
    case key do
      "h" -> :cursor_left
      "j" -> :cursor_down
      "k" -> :cursor_up
      "l" -> :cursor_right
      "0" -> :start_of_line
      "$" -> :end_of_line
      "g" -> :top
      "G" -> :bottom
      "q" -> Process.exit(self(), :normal)
      _ -> nil
    end
  end
