defmodule DahliaWeb.LiveHelper do
  @moduledoc """
  Difines common functions for LiveViews.
  """

  @doc """
  Returns the topic of the user
  """
  def topic(topic, socket) do
    user = socket.assigns.current_user
    topic <> ":" <> user.id
  end
end
