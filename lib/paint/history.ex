defmodule History do
  defstruct [
    previous: [],
    next: [],
    cache: ""
  ]

  def new, do: %__MODULE__{}

  def set_cache(history, str), do: %__MODULE__{history | cache: str}

  def set(history, str) do
    new_history = reset(history)
    %__MODULE__{new_history | previous: [str | new_history.previous]}
  end

  def reset(%{previous: previous, next: next} = history) do
    %__MODULE__{history | previous: Enum.reverse(next) ++ previous}
  end

  def previous(%{previous: []} = history), do: history
  def previous(%{previous: [_]} = history), do: history
  def previous(%{previous: [current | previous], next: next} = history) do
    %__MODULE__{history | previous: previous, next: [current | next]}
  end

  def next(%{next: []} = history), do: history
  def next(%{previous: previous, next: [current | next]} = history) do
    %__MODULE__{history | previous: [current | previous], next: next}
  end

  def current(%{previous: [], cache: cache}), do: cache
  def current(%{previous: [str | _]}), do: str
end
