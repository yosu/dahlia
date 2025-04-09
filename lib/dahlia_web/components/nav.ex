defmodule DahliaWeb.Nav do
  @moduledoc false
  use Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
     |> attach_hook(:active_menu, :handle_params, &set_active_menu/3)}
  end

  defp set_active_menu(_params, _url, socket) do
    active_menu =
      case socket.view do
        DahliaWeb.WaterBillLive -> :water
        DahliaWeb.GasBillLive -> :gas
        _ -> :none
      end

    {:cont, assign(socket, :active_menu, active_menu)}
  end
end
