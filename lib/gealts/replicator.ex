defmodule Gealts.Replicator do
  @moduledoc """
  Puts chromosomes through a fitness based, roulette wheel selection process.
  "Stronger" chromosomes have a higher probability to be chosen for 
  replication to be part of the new population of chromosomes.
  """

  alias Gealts.MathUtils

  @doc """
  Select chromosomes for replication. Roulette wheel selction is used.
  See moduledoc.
  """
  @spec select([Gealts.Chromosome.t]) :: [Gealts.Chromosome.t]
  def select(chromes) do
    r = MathUtils.random_list(length(chromes))
    c = calc_cum_probabilities(chromes)
    roulette_wheel(r, c, chromes)
  end

  @spec calc_cum_probabilities([Gealts.Chromosome.t]) :: [float]
  defp calc_cum_probabilities(chromes) do
    calc_cum_probabilities(chromes, 1, [])
  end
  defp calc_cum_probabilities(chromes, n, acc) when n > length(chromes) do
    acc |> Enum.reverse
  end
  defp calc_cum_probabilities(chromes, n, acc) do
    c = chromes
    |> Enum.take(n)
    |> Enum.reduce(0, fn(chrome, acc) -> chrome.probability + acc end)

    calc_cum_probabilities(chromes, n + 1, [c | acc])
  end

  @spec roulette_wheel([float], [float], [Gealts.Chromosome.t]) :: [Gealts.Chromosome.t]
  defp roulette_wheel(r, c, chromes) do
    roulette_wheel(r, c, chromes, [])
  end
  defp roulette_wheel([], _c, _chromes, new_chromes) do
    new_chromes |> Enum.reverse
  end
  defp roulette_wheel([r | rest], c, chromes, new_chromes) do
    roulette_wheel(rest, c, chromes, [Enum.at(chromes, find_position(r, c)) | new_chromes])
  end

  @spec find_position(float, [float]) :: non_neg_integer
  defp find_position(r, c), do: find_position(r, 0, c, 0)
  defp find_position(_r, _cur, [], i), do: i
  defp find_position(r, cur, [next | _rest], i) when r > cur and r < next, do: i
  defp find_position(r, _cur, [next | rest], i), do: find_position(r, next, rest, i + 1)
end
