defmodule Stdin do
  def start do
    parent = self()
    spawn(fn() -> run_loop(parent) end)
  end

  def get_key do
    receive do
      {:get_char, ""} -> get_key("")
      {:get_char, c} -> c
    end
  end

  defp get_key(key) do
    receive do
      {:get_char, c} -> get_key(key <> c)
    after
      10 -> key
    end
  end

  defp run_loop(pid) do
    send(pid, {:get_char, IO.getn('', 1)})
    run_loop(pid)
  end
end
