defmodule State do
  defstruct [
    filename: "",
    color: "",
    image: nil,
    main: nil,
    status: nil,
    command: nil,
    undo: [],
    redo: []
  ]

  def new(filename, width, height, image) do
    %__MODULE__{
      filename: filename,
      color: "#{Tput.op()} ",
      image: image,
      main: Window.new(0, 0, width, height - 2),
      status: StatusLine.new(height - 2, width),
      command: Window.new(0, height - 1, width, 1)
    }
  end

  def refresh_status_line(state) do
    StatusLine.refresh(state.status, [
      state.filename,
      "  (#{state.main.cursor_x}, #{state.main.cursor_y})  ",
      "#{current_color(state)} ",
      " #{state.color} #{Tput.op()}",
      "  (#{Image.width(state.image)},#{Image.height(state.image)})"
    ])
  end

  def current_color(%{image: image, main: main}) do
    Image.get(image, main.cursor_x, main.cursor_y)
  end
end
