defmodule CommandLine do
  defstruct [
    window: nil,
    text: "",
    history: nil,
  ]

  @esc ""
  @backspace <<127>>
  @delete "[3~"
  @right "[C"
  @left "[D"
  @up "[A"
  @down "[B"

  def new(y, width) do
    %__MODULE__{
      window: Window.new(0, y, width, 1),
      history: History.new
    }
  end

  def run(cl) do
    result = cl |> clear_line() |> loop()
    result |> clear_line() |> refresh()
    result
  end

  def refresh(%{window: window, text: text}, prefix \\ " ") do
    Window.refresh(%{window | cursor_x: 0}, [[prefix, text, " "]])
  end

  def loop(%{window: %{cursor_x: cursor_x}} = cl) do
    refresh(cl, ":")
    Terminal.set_cursor(cursor_x + 1, cl.window.y)
    case Stdin.get_key() do
      "\r"       -> cl |> set_history()
      @esc       -> %{cl | text: "", history: History.reset(cl.history)}
      ""       -> %{cl | text: "", history: History.reset(cl.history)}

      ""       -> cl |> cursor_right() |> loop()
      ""       -> cl |> cursor_left()  |> loop()
      @right     -> cl |> cursor_right() |> loop()
      @left      -> cl |> cursor_left() |> loop()
      ""       -> cl |> cursor_begin_of_line() |> loop()
      ""       -> cl |> cursor_end_of_line() |> loop()

      @backspace -> cl |> backspace() |> cursor_left() |> loop()
      @delete    -> cl |> delete() |> loop()

      ""       -> cl |> history_previous() |> loop()
      ""       -> cl |> history_next() |> loop()
      @up        -> cl |> history_previous() |> loop()
      @down      -> cl |> history_next() |> loop()

      @esc <> _  -> loop(cl)
      key        ->
        cl |> insert(key) |> cursor_right(String.length(key)) |> loop()
    end
  end

  def cursor_left(%{window: window, text: text} = cl, count \\ 1) do
    text_width = String.length(text) + 1
    new_x = window.scroll_x + window.cursor_x - count
    new_window = Window.change_cursor_x(window, new_x, text_width)
    %{cl | window: new_window}
  end

  def cursor_right(%{window: window, text: text} = cl, count \\ 1) do
    text_width = String.length(text) + 1
    new_x = window.scroll_x + window.cursor_x + count
    new_window =
      if new_x > text_width do
        window
      else
        Window.change_cursor_x(window, new_x, text_width)
      end
    %{cl | window: new_window}
  end

  def cursor_begin_of_line(%{window: window} = cl) do
    new_window = Window.change_cursor_x(window, 0, 1)
    %{cl | window: new_window}
  end

  def cursor_end_of_line(%{window: window, text: text} = cl) do
    text_width = String.length(text)
    new_window = Window.change_cursor_x(window, text_width, text_width + 1)
    %{cl | window: new_window}
  end

  def backspace(%{window: %{cursor_x: cursor_x}, text: text} = cl) do
    %{cl | text: remove_char(cursor_x - 1, text)}
    |> set_history_cache()
  end

  def delete(%{window: %{cursor_x: cursor_x}, text: text} = cl) do
    %{cl | text: remove_char(cursor_x, text)}
    |> set_history_cache()
  end

  def clear_line(cl), do: %{cl | text: ""} |> cursor_begin_of_line()

  def insert(%{window: %{cursor_x: cursor_x}, text: text} = cl, key) do
    %{cl | text: insert_at(text, cursor_x, key)}
    |> set_history_cache()
  end

  def remove_char(-1, text), do: text
  def remove_char(x, text) do
    case String.split_at(text, x) do
      {prefix, ""} -> prefix
      {prefix, <<_>> <> suffix} -> prefix <> suffix
    end
  end

  def insert_at(text, index, value) do
    {prefix, suffix} = String.split_at(text, index)
    prefix <> value <> suffix
  end

  def set_history_cache(cl) do
    %{cl | history: History.set_cache(cl.history, cl.text)}
  end

  def set_history(%{text: text, history: history} = cl) do
    %{cl | history: History.set(history, text)}
  end

  def history_previous(cl) do
    history = History.previous(cl.history)
    %{cl | history: history}
    |> set_text(History.current(cl.history))
  end

  def history_next(cl) do
    history = History.next(cl.history)
    text =
      if cl.history.next == [] do
        cl.history.cache
      else
        History.current(cl.history)
      end
    %{cl | history: history}
    |> set_text(text)
  end

  def set_text(%{window: window} = cl, text) do
    %{cl |
      window: %{window | cursor_x: String.length(text)},
      text: text
    }
  end
end
