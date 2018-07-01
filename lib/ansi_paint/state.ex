defmodule State do
  defstruct [
    image: nil,
    main: nil,
    status: nil,
    command: nil
  ]

  def new(width, height, image) do
    %__MODULE__{
      image: image,
      main: Window.new(0, 0, width, height - 2),
      status: Window.new(0, height - 2, width, 1),
      command: Window.new(0, height - 1, width, 1)
    }
  end
end
