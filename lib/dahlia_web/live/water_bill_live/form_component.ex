defmodule DahliaWeb.WaterBillLive.FormComponent do
  use DahliaWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="water-bill-evidence-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.live_file_input upload={@uploads.photo} />
        <div :for={entry <- @uploads.photo.entries}>
          <.live_img_preview entry={entry} width="75" />

          <progress max="100" value={entry.progress} />

          <.button phx-click="cancel-upload" phx-value-ref={entry.ref} phx-target={@myself}>cancel</.button>

          <.error :for={err <- upload_errors(@uploads.photo, entry)}>{Phoenix.Naming.humanize(err)}</.error>
        </div>

        <:actions>
          <.button phx-disable-with="保存中...">保存</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, allow_upload(socket, :photo, accept: ~w(.png .jpg .jpeg))}
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign_new(:form, fn ->
        to_form(%{})
      end)
    }
  end

  @impl true
  @spec handle_event(<<_::32, _::_*8>>, any(), any()) :: {:noreply, any()}
  def handle_event("validate", _params, socket) do
    # We must implement minimal callback so that the upload validation works properly
    # https://hexdocs.pm/phoenix_live_view/uploads.html#entry-validation
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    {:noreply,
    socket
    |> put_flash(:info, "保存しました")
    |> push_patch(to: ~p"/water")
  }
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end

end
