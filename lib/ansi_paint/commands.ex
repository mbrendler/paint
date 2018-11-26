defmodule Commands do
  require Commands.Cursor
  require Commands.LifeCycle

  @commands [
    Commands.Cursor,
    Commands.LifeCycle,
    Commands.Paint,
  ]
  |> Enum.flat_map(
    fn mod ->
      mod.__info__(:functions)
      |> Enum.filter(fn {_, c} -> c == 2 end)
      |> Enum.map(fn {k, _} -> {k, mod} end)
    end
  )
  |> Enum.into(%{})

  def lala, do: @commands

  def run(nil, state), do: state
  def run([], state), do: state
  def run([cmd | args], state) when is_binary(cmd) do
    run([String.to_atom(cmd) | args], state)
  end
  def run([cmd | args], state) do
    mod = @commands[cmd]
    case mod do
      nil -> state
      _ -> apply(mod, cmd, [state, args]) # |> refresh_if_needed(state)
    end
  end
  def run(cmd, state) do
    run([cmd], state) |> refresh_if_needed(state)
  end

  def should_refresh(state, old_state) do
    state.main.scroll_x != old_state.main.scroll_x ||
      state.main.scroll_y != old_state.main.scroll_y ||
      state.image != old_state.image
  end

  def refresh_if_needed(state, old_state) do
    if should_refresh(state, old_state) do
      Commands.LifeCycle.refresh(state)
    else
      State.refresh_status_line(state)
      Commands.LifeCycle.refresh_cursor(state)
    end
  end
end
