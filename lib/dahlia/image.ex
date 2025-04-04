defmodule Dahlia.Image do
  @moduledoc """
  Image processing functions.
  """

  @doc """
  Reduce photo region and file size.
  """
  def compact!(name, raw) do
    org = Image.from_binary!(raw)

    {left, top, width, height} =
      org
      |> Image.to_colorspace!(:bw)
      |> Image.blur!(sigma: 20.0)
      |> Image.contrast!(1.2)
      |> Image.find_trim!(threshold: 100)

    data =
      org
      |> Image.crop!(left, top, width, height)
      |> Image.thumbnail!(1000)
      |> Image.write!(:memory, suffix: ".webp")

    {webp_name(name), data}
  end

  defp webp_name(name) do
    Path.rootname(name) <> ".webp"
  end
end
