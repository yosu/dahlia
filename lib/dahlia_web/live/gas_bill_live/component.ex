defmodule DahliaWeb.GasBillLive.Component do
  use DahliaWeb, :component

  attr :summary, :any, required: true
  slot :inner_block, required: true

  def summary_cell(assigns) do
    ~H"""
    <td class="pl-4">
      <.link patch={~p"/gas/#{@summary.evidence_id}/summary/edit"}>
        {render_slot(@inner_block)}
      </.link>
    </td>
    """
  end

  attr :summaries, :list, required: true

  def summary_table(assigns) do
    ~H"""
    <table class="p-2">
      <thead>
        <th class="px-4">請求日</th>
        <th class="px-4">ガス料金</th>
        <th class="px-4">使用量</th>
        <th></th>
      </thead>
      <tbody>
        <tr :for={summary <- @summaries} id={summary.id} class="py-2">
          <.summary_cell summary={summary}>{summary.read_date}</.summary_cell>
          <.summary_cell summary={summary}>{summary.charge}円</.summary_cell>
          <.summary_cell summary={summary}>{summary.usage}㎥</.summary_cell>
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
