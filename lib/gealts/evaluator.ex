defmodule Gealts.Evaluator do
	@moduledoc """
	Exposes functions for evaluating
  chromosome populations, such as calculating individual
  fitness, probabilities, etc.
  """
	
	@doc """
	Evaluate chromosome values by eval_fun(values).
	"""
	@spec calc_evaluation([Gealts.Chromosome.t], (list -> number)) :: [Gealts.Chromosome.t]
	def calc_evaluation(chromes, eval_fn) do
		Enum.map(chromes, fn chrome ->
			%{chrome | evaluation: eval_fn.(chrome.values)}
		end)
	end

	@doc """
	Calculate fitness scores of individual chromosomes.
	"""
	@spec calc_fitness([Gealts.Chromosome.t]) :: [Gealts.Chromosome.t]
	def calc_fitness(chromes) do
		Enum.map(chromes, fn chrome ->
			%{chrome | fitness: fitness_fun(chrome.evaluation)}
		end)
	end

	@doc """
	Calculate probabilities of individual chromsomes.
	Here "probability" is the likelyhood of chromosome n
	being selected as a chromosome of population n+1.
	"""
	@spec calc_probabilities([Gealts.Chromosome.t], float) :: [Gealts.Chromosome.t]
	def calc_probabilities(chromes, total_fitness) do
		Enum.map(chromes, fn chrome ->
			%{chrome | probability: chrome.fitness / total_fitness}
		end)
	end

	# internal
	# Could be user supplied later on.
	defp fitness_fun(n) do
		1 / (1 + n)
	end
end
