defmodule Commands.LifeCycle do
  def quit(_, _), do: Process.exit(self(), :normal)
  def q(_, _), do: quit(nil, nil)

  def undo(%{undo: []} = state, _), do: state
  def undo(%{undo: [old_state | old_states], redo: redo} = state, _) do
    %{old_state | undo: old_states, redo: [state | redo]}
  end

  def redo(%{redo: []} = state, _), do: state
  def redo(%{redo: [old_state | old_states], undo: undo} = state, _) do
    %{old_state | redo: old_states, undo: [state | undo]}
  end

  def command_line(%{command: command_line} = state, _) do
    new_command_line = CommandLine.run(command_line)
    new_command_line.text
    |> String.split()
    |> Commands.run(%{state | command: new_command_line})
  end

  def refresh(%{main: main, image: image} = state, _ \\ nil) do
    Window.refresh(main, image)
    State.refresh_status_line(state)
    refresh_cursor(state)
  end

  def refresh_cursor(%{main: main} = state, _ \\ nil) do
    Terminal.set_cursor(main.cursor_x, main.cursor_y)
    state
  end
end
