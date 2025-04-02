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
        <!--.input field={@form[:id]} type="text" label="Issue" /-->
        <!--.input field={@form[:title]} type="text" label="タイトル" /-->

        <:actions>
          <.button phx-disable-with="保存中...">保存</.button>
        </:actions>
      </.simple_form>
    </div>
    """
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
  def handle_event("validate", _params, socket) do
    IO.puts("validate")
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    IO.puts("save")
    {:noreply, socket}
  end

end
