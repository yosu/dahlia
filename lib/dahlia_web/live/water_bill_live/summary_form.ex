defmodule DahliaWeb.WaterBillLive.SummaryForm do
  use DahliaWeb, :live_component

  alias Dahlia.Bill

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <img src={~p"/water/evidences/#{@evidence_id}"} class="sticky top-0" />

      <.simple_form
        for={@form}
        id="water-bill-summary-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input type="hidden" field={@form[:evidence_id]} value={@evidence_id} />
        <div class="flex gap-x-8">
          <.input type="date" field={@form[:bill_date]} label="請求日" />
          <.input type="date" field={@form[:due_date]} label="納付期限" />
        </div>
        <div class="flex gap-x-8">
          <.input type="number" field={@form[:water_charge]} label="上水道料金" />
          <.input
            type="number"
            field={@form[:water_charge_internal_tax]}
            label="うち消費税（上水道料金）"
          />
        </div>
        <div class="flex gap-x-8">
          <.input type="number" field={@form[:sewer_charge]} label="下水道使用料" />
          <.input
            type="number"
            field={@form[:sewer_charge_internal_tax]}
            label="うち消費税（下水道使用料）"
          />
        </div>
        <div class="flex gap-x-8">
          <.input type="number" field={@form[:current_read]} label="今回指針" />
          <.input type="date" field={@form[:current_read_date]} label="検針日（今回指針）" />
        </div>
        <div class="flex gap-x-8">
          <.input type="number" field={@form[:previous_read]} label="前回指針" />
          <.input type="date" field={@form[:previous_read_date]} label="検針日（前回指針）" />
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
    {:ok, socket}
  end

  @impl true
  def update(%{summary: summary} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Bill.change_summary(summary))
     end)}
  end

  @impl true
  def handle_event("validate", %{"water_bill_summary" => summary_params}, socket) do
    changeset = Bill.change_summary(socket.assigns.summary, summary_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"water_bill_summary" => summary_params}, socket) do
    save_summary(summary_params, socket)
  end

  defp save_summary(params, socket) do
    IO.inspect(params, label: "save_summary")
    case Bill.create_summary(params) do
      {:ok, summary} ->
        IO.inspect(summary, label: "ok")
        notify_parent({:saved, summary})

        {:noreply,
         socket
         |> put_flash(:info, "保存しました")
         |> push_patch(to: ~p"/water")}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "error")
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp notify_parent(msg) do
    send(self(), {__MODULE__, msg})
  end
end
