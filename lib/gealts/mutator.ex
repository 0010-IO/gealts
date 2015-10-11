defmodule Gealts.Mutator do
  @moduledoc """
  Runs chromosomes through a random mutation process.
  Randomly selected individual genes (number of which is
  specified by the @pm paramter) are replaced with new
  random values.
  """

  alias Gealts.MathUtils

  @pm 0.1 # 10%

  @doc """
  Take a population of chromosomes, calculate the total number of genes,
  calculate the number of mutations (in other words, number of individual genes
  to be replaced) and finally mutate genes.
  """
  @spec mutate([Gealts.Chromosome.t, ...], map) :: []
  def mutate(chromes, config) do
    total_gen = calc_total_gen(chromes)
    num_mutations = round(@pm * total_gen)
    positions = MathUtils.random_values_list(num_mutations, total_gen)
    do_mutate(chromes, positions, config)
  end

  @spec do_mutate([Gealts.Chromosome.t], [non_neg_integer], map) :: [Gealts.Chromosome.t]
  defp do_mutate(chromes, [], _config) do
    chromes
  end
  defp do_mutate(chromes, [pos | rest], config) do
    {row, col} = calc_row_col(pos, length(Enum.at(chromes, 0).values))
    chrome = Enum.at(chromes, row)
    nvalues = List.replace_at(chrome.values, col, MathUtils.random_int(config[:min_val], config[:max_val]))
    do_mutate(List.replace_at(chromes, row, %{chrome | values: nvalues}), rest, config)
  end

  @spec calc_row_col(non_neg_integer, non_neg_integer) :: {non_neg_integer, non_neg_integer}
  defp calc_row_col(ind, num) do
    {round(Float.floor((ind - 1)/ num)),
     rem(ind - 1, num)}
  end

  @spec calc_total_gen([Gealts.Chromosome.t]) :: non_neg_integer
  defp calc_total_gen([chrome | chromes]) do
    length(chrome.values) * (length(chromes) + 1)
  end
end
