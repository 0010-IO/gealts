defmodule Gealts.Crossover do
  @moduledoc """
  Randomly selects a position in a chromosome, then
  exchanges sub-chromosomes.
  Chromosomes fit for "mating" are randomly selected,
  the number of parent chromosomes is controlled by the 
  @cr (crossover rate) parameter.
  """

  alias Gealts.MathUtils

  @cr 0.25

  @type ind_chrome :: {non_neg_integer, Gealts.Chromosome.t}
  @type mates :: {ind_chrome, ind_chrome}

  @doc """
  Select chromosomes fit for mating.
  Pair chromosomes together and merge their 
  sub-chromosome populations based on a randomly selected cutoff point.
  Update original chromosome population.
  """
  @spec mate([Gealts.Chromosome.t]) :: [Gealts.Chromosome.t]
  def mate(chromes) do
    chromes
    |> select
    |> link
    |> merge
    |> update(chromes)
  end

  @spec select([Gealts.Chromosome.t]) :: [ind_chrome]
  defp select(chromes) do
    select(chromes, MathUtils.random_list(length(chromes)), 0, [])
  end
  defp select(_chromes, [], _i, acc) do
    acc |> Enum.reverse
  end
  defp select(chromes, [r | rest], i, acc) when r > @cr do
    select(chromes, rest, i + 1, acc)
  end
  defp select(chromes, [_r | rest], i, acc) do
    select(chromes, rest, i + 1, [{i, Enum.at(chromes, i)} | acc])
  end

  @spec link([ind_chrome]) :: [mates]
  defp link([]) do
    []
  end
  defp link(chromes) do
    link(chromes, Enum.at(chromes, 0), [])
  end
  defp link([], _first, acc) do
    acc |> Enum.reverse
  end
  defp link([a, b | chromes], first, acc) do
    link([b | chromes], first, [{a, b} | acc])
  end
  defp link([a | chromes], first, acc) do
    link(chromes, first, [{a, first} | acc])
  end

  @spec merge([mates]) :: [ind_chrome]
  defp merge([]) do
    []
  end
  defp merge(chromes) do
    vals = for _ <- 1..length(chromes), do: MathUtils.random_int(1, 4)
      merge(chromes, vals, [])
  end
  defp merge([], _vals, acc) do
    Enum.reverse(acc)
  end
  defp merge([{{pos, chrome_a}, {_pos, chrome_b}} | rest ], [val | vals], acc) do
    merged = Enum.slice(chrome_a.values, 0, val) ++ Enum.slice(chrome_b.values, val, length(chrome_b.values))
    merge(rest, vals, [{pos, %{chrome_a | values: merged}} | acc])
  end

  @spec update([ind_chrome], [Gealts.Chromosome.t]) :: [Gealts.Chromosome.t]
  defp update([], chromes) do
    chromes
  end
  defp update([{n, chrome} | rest], chromes) do
    update(rest, List.replace_at(chromes, n, chrome))
  end
end
