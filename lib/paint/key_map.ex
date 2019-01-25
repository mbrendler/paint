defmodule KeyMap do
  def handle(key) do
    case key do
      "h" -> :left
      "j" -> :down
      "k" -> :up
      "l" -> :right
      "0" -> :start_of_line
      "$" -> :end_of_line
      "g" -> :top
      "G" -> :bottom

      "p" -> :pick
      " " -> :set
      "" -> :set_and_next
      "f" -> :fill

      "u" -> :undo
      "" -> :redo

      "r" -> :refresh
      ":" -> :command_line
      "q" -> :quit
      _ -> nil
    end
  end

  # 'H' => :scroll_left,
  # 'J' => :scroll_down,
  # 'K' => :scroll_up,
  # 'L' => :scroll_right,
  # '' => :scroll_up,
  # '' => :scroll_down,
  # 'w' => :next_color,
  # 'e' => :end_color,
  # 'b' => :previous_color,
end
