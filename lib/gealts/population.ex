defmodule Gealts.Population do
	@moduledoc """
	Represents a population of chromosomes.
	Exposes function for manipulating, evaluating, mutating, etc.
	chromosomes.
  """

	alias Gealts.Chromosome
	alias Gealts.Evaluator
	alias Gealts.Replicator
	alias Gealts.Crossover
	alias Gealts.Mutator
	
	defstruct population: [], iteration: 0, config: %{}

	@doc """
	Start Population agent.
	Accepts a list of chromosomes that will act as population gen 0 as
	well as a config map.
  """
	@spec start_link([Chromosome.t], map) :: Agent.on_start()
	def start_link(chromes, config) do
		Agent.start_link(fn -> %__MODULE__{population: chromes, config: config} end, name: __MODULE__)
	end

	@doc """
	Stop Population agent.
  """
	@spec stop() :: :ok
	def stop do
		Agent.stop(__MODULE__)
	end

	@doc """
	Returns the current population of chromosomes.
  """
	@spec population() :: [Chromosome.t]
	def population do
		Agent.get(__MODULE__, fn state -> state.population end)
	end

	@doc """
	Iterates n number of times, altering the chromosome population by performing the
	whole genetic mutation process of evaluation,
	fitness and probabilities updating, replication, crossover and
	finally mutation.
  """
	@spec iterate(non_neg_integer()) :: :ok
	def iterate(0) do
		population
		|> eval_and_fitness(config()[:eval_fn])
		|> update_population
		:ok
	end
	def iterate(n) do
		evaluated = eval_and_fitness(population, config()[:eval_fn])
		tf = total_fitness(evaluated)

		evaluated
		|> probabilities(tf)
		|> replicate_and_crossover
		|> mutate(config())
		|> update_population

		inc_iteration()

		iterate(n - 1)
	end

	@doc """
	Returns the best chromosome of the 
	population based on its fitness
	score.
  """
	@spec best() :: Chromosome.t
	def best do
		population
		|> Enum.sort_by(fn chrome -> chrome.fitness end, &>=/2)
		|> List.first
	end

	# internal

	@spec config() :: map
	def config do
		Agent.get(__MODULE__, fn state -> state.config end)
	end
	
	@spec update_population([Chromosome.t]) :: :ok
	defp update_population(p) do
		Agent.update(__MODULE__, fn state -> %{state | population: p} end)
	end

	@spec inc_iteration() :: :ok
	defp inc_iteration do
		Agent.update(__MODULE__, fn state -> %{state | iteration: state.iteration + 1} end)
	end

	@spec total_fitness([Chromosome.t]) :: float
	defp total_fitness(chromes) do
		chromes
		|> Enum.map(fn chrome -> chrome.fitness end)
		|> Enum.reduce(0, fn(f, acc) -> f + acc end)
	end

	@spec eval_and_fitness([Chromosome.t], (list -> number)) :: [Chromosome.t]
	defp eval_and_fitness(chromes, eval_fn) do
		chromes
		|> Evaluator.calc_evaluation(eval_fn)
		|> Evaluator.calc_fitness
	end

	@spec probabilities([Chromosome.t], float) :: [Chromosome.t]
	defp probabilities(chromes, fitness) do
		Evaluator.calc_probabilities(chromes, fitness)
	end

	@spec replicate_and_crossover([Chromosome.t]) :: [Chromosome.t]
	defp replicate_and_crossover(chromes) do
		chromes
		|> Replicator.select
		|> Crossover.mate
	end

	@spec mutate([Chromosome.t], map) :: [Chromosome.t]
	defp mutate(chromes, config) do
		Mutator.mutate(chromes, config)
	end
end
