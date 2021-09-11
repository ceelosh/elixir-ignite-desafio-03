defmodule GenReport do
  alias GenReport.Parser
  @workers [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def build(filename) do
    filename
    |> Parser.parse_line()
    |> Enum.reduce(report(), fn line, report -> sum_values(line, report) end)
  end

  def build(_filename), do: {:error, "Insira o nome de um arquivo"}

  defp sum_values([name, quantidade, _dia, mes, ano], %{"all_hours" => all_hours, "hours_per_month" => hours_per_month, "hours_per_year" => hours_per_year} = report) do
    all_hours = Map.put(all_hours, name, report[name] + quantidade)
    hours_per_month = Map.put(hours_per_month, name, report[name][mes] + quantidade)
    hours_per_year = Map.put(hours_per_year, name, report[name][ano] + quantidade)

    build_report(all_hours, hours_per_month, hours_per_year)
    |> IO.inspect()
  end

  defp report() do
    all_hours = Enum.into(@workers, %{}, &{&1, 0})
    hours_per_month = Enum.into(@months, %{}, &{&1, 0})
    hours_per_year = Enum.into(@workers, %{}, &{&1, 0})

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp build_report(all_hours, hours_per_month, hours_per_year), do: %{"all_hours" => all_hours, "hours_per_month" => hours_per_month, "hours_per_year" => hours_per_year}
end
