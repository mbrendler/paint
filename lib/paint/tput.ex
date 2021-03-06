defmodule Tput do
  use GenServer

  %{
    up: "cuu1",
    down: "cud1",
    left: "cub1",
    right: "cuf1",
    op: "op",
    clear_to_eol: "el",
    bold: "bold",
    reset: "sgr0",
    italic: "sitm"
  } |> Enum.each(fn {name, cap} ->
    def unquote(name)(), do: tput([unquote(cap)])
  end)

  def background_color(number), do: tput(["setab", to_string(number)])

  def foreground_color(number), do: tput(["setaf", to_string(number)])

  def background_color_number(""), do: 0
  def background_color_number(str) do
    Enum.find((0..255), 0, &String.contains?(str, background_color(&1)))
  end

  def set_cursor(x, y), do: tput(["cup", to_string(y), to_string(x)])

  def tput(args), do: GenServer.call(__MODULE__, {:tput, args})

  # GenServer -----------------------------------------------------------------

  def start_link, do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(_args), do: {:ok, :ets.new(:buckets_registry, [:set])}

  def handle_call({:tput, args}, _from, store) do
    result = case :ets.lookup(store, args) do
      [{_, value}] -> value
      _ -> _store(store, args, _tput(args))
    end
    {:reply, result, store}
  end

  defp _tput(args) do
    term = System.get_env("TERM") || "xterm-256color"
    {escape_sequence, 0} = System.cmd("tput", ["-T", term | args])
    # {escape_sequence, 0} = System.cmd("tput", args)
    escape_sequence
  end

  defp _store(store, args, value) do
    :ets.insert(store, {args, value})
    value
  end
end
