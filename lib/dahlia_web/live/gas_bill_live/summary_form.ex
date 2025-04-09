defmodule DahliaWeb.GasBillLive.SummaryForm do
  alias Dahlia.Bill.GasBillSummary
  use DahliaWeb, :live_component

  alias Dahlia.Bill
  alias Dahlia.Bill.GasBillSummary

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <img src={~p"/gas/evidences/#{@evidence_id}"} class="sticky top-0" />

      <.simple_form
        for={@form}
        id="gas-bill-summary-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input type="hidden" field={@form[:evidence_id]} value={@evidence_id} />
        <.input type="date" field={@form[:read_date]} label="請求日" />
        <.input type="number" field={@form[:charge]} label="料金" />
        <.input type="number" field={@form[:usage]} label="使用量" />

        <:actions>
          <.button phx-disable-with="保存中...">保存</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{summary: summary} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(GasBillSummary.changeset(summary))
     end)}
  end

  @impl true
  def handle_event("validate", %{"gas_bill_summary" => summary_params}, socket) do
    changeset = GasBillSummary.changeset(socket.assigns.summary, summary_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"gas_bill_summary" => summary_params}, socket) do
    save_summary(summary_params, socket.assigns.action, socket)
  end

  defp save_summary(params, :summary_new, socket) do
    case Bill.create_gas_summary(params) do
      {:ok, summary} ->
        notify_parent({:saved, summary})

        {:noreply,
         socket
         |> put_flash(:info, "保存しました")
         |> push_patch(to: ~p"/gas")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_summary(params, :summary_edit, socket) do
    case Bill.update_gas_summary(socket.assigns.summary, params) do
      {:ok, summary} ->
        notify_parent({:updated, summary})

        {:noreply,
         socket
         |> put_flash(:info, "保存しました")
         |> push_patch(to: ~p"/gas/summary")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp notify_parent(msg) do
    send(self(), {__MODULE__, msg})
  end
end
