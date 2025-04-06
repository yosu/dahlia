defmodule DahliaWeb.WaterBillLive.Component do
  use DahliaWeb, :component

  alias Dahlia.Bill.WaterBillSummary

  attr :summary, :any, required: true
  slot :inner_block, required: true

  def summary_cell(assigns) do
    ~H"""
    <td class="pl-4">
      <.link patch={~p"/water/#{@summary.evidence_id}/summary/edit"}>
        {render_slot(@inner_block)}
      </.link>
    </td>
    """
  end

  def summary_table(assigns) do
    ~H"""
    <table class="p-2">
      <thead>
        <th class="px-4">請求日</th>
        <th class="px-4">請求金額</th>
        <th></th>
      </thead>
      <tbody id="summary-list" phx-update="stream">
        <tr :for={{dom_id, summary} <- @streams.summaries} id={dom_id} class="py-2">
          <.summary_cell summary={summary}>{summary.bill_date}</.summary_cell>
          <.summary_cell summary={summary}>{WaterBillSummary.total_charge(summary)}円</.summary_cell>
          <td>
            <.link
              class="text-red-500"
              phx-click={JS.push("delete", value: %{"id" => summary.evidence_id})}
              data-confirm="本当に削除しますか？"
            >
              削除
            </.link>
          </td>
        </tr>
      </tbody>
    </table>
    """
  end
end
