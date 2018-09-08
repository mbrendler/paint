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

      "p" -> :pick
      " " -> :set
      "" -> :set_and_next
      "f" -> :fill

      "u" -> :undo
      "R" -> :redo

      "r" -> :refresh
      ":" -> :command_line
      "q" -> Process.exit(self(), :normal)
      _ -> nil
    end
  end

  # 'u' => :cmd_undo,
  # 'R' => :cmd_redo,
  # 'H' => :scroll_left,
  # 'J' => :scroll_down,
  # 'K' => :scroll_up,
  # 'L' => :scroll_right,
  # '' => :scroll_up,
  # '' => :scroll_down,
  # 'w' => :next_color,
  # 'e' => :end_color,
  # 'b' => :previous_color,
  # ':' => :command,
  # 'q' => :cmd_quit
end
