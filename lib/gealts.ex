defmodule Gealts do
  @moduledoc """
  Gealts is a basic implementation of a genetic
  algorithm based on http://arxiv.org/pdf/1308.4675.pdf
  
  exposed functions:

       Gealts.start/1
       Gealts.iterate/1
       Gealts.best/0
       Gealts.population/0
       Gealts.config/0
  """
  alias Gealts.Population
  alias Gealts.Chromosome
  alias Gealts.MathUtils

  @doc """
  Starts the "population" agent.
  A config map must be provided. The config values are:
  
        :input (optional)   
    
  A list of lists with prepopulated chromosomes. 
        
        For example: [
          [18, 298, 37],
          [87, 242, 1],
          [90, 0, 1]
        ]
                        
  Input will be used as gen 0 of population.
  Empty by default, chromosomes will be generated
  randomly based on :min_val, :max_val, :genes and :chromes.

        :min_val (optional)
  
  Gene minimum. When mutating genes (see Gealts.Mutator) and
  generating new values, :min_val will act as floor of random ranges.
  Defaults to 0.
  
        :max_val
  
  Gene maximum. When mutating genes (see Gealts.Mutator) and
  generating new values, :max_val will act as ceiling of random ranges.

        :genes (optional when input is provided)
  
  Max number of genes (values) in each individual chromosome.

        :chromes (optional when input is provided)
  
  Max number of chromes in a population.

        :eval_fn 
  
  Evaluation function. Applied to chromosome values upon each iterration.
  Should takes a list and return a number.
          
        For example: 
        (fn [a, b, c, d] -> 
          :erlang.abs((a + 2 * b + 3 * c + 4 * d) - 30) 
        end)                      
  """
  @spec start(map) :: Agent.on_start()
  def start(config) do
    do_start(validate(config))
  end

  @doc """
  Performs n number of itererations, 
  altering chromosome population in the process.
  """
  @spec iterate(non_neg_integer) :: :ok
  def iterate(n) do
    Population.iterate(n)
  end

  @doc """
  Returns the "best" (most fittest) chromosome of current population.
  """
  @spec best() :: Chromosome.t
  def best do
    Population.best
  end

  @doc """
  Returns current population.
  """
  @spec population() :: [Chromosome.t]
  def population do
    Population.population
  end

  @doc """
  Returns current config.
  """
  @spec config() :: map
  def config do
    Population.config
  end

  # internal
  @spec do_start(map) :: Agent.on_start()
  defp do_start(config = %{input: []}) do
    input = for _ <- 1..config[:chromes] do
      MathUtils.random_values_list(config[:genes],
                                   config[:min_val],
                                   config[:max_val])
    end
    start(%{config | input: input})
  end
  defp do_start(config = %{input: input}) when is_list(input) do
    input
    |> Enum.map(fn input -> %Chromosome{values: input} end)
    |> Population.start_link(config)
  end

  @spec validate(map) :: map
  defp validate(config = %{input: _input, min_val: _min_val}) do
    validate(config, :max_val)
  end
  defp validate(config = %{input: _input}) do
    config
    |> Map.put(:min_val, 0)
    |> validate(:max_val)
  end
  defp validate(config = %{min_val: _min_val}) do
    config
    |> Map.put(:input, [])
    |> validate(:max_val)
  end
  defp validate(config) do
    config
    |> Map.put(:input, [])
    |> Map.put(:min_val, 0)
    |> validate(:max_val)
  end
  defp validate(config = %{max_val: max_val}, :max_val) when is_number(max_val) and max_val > 0 do
    validate(config, :genes)
  end
  defp validate(config = %{input: [], genes: genes}, :genes) when is_number(genes) and genes > 0 do
    validate(config, :chromes)
  end
  defp validate(config = %{input: [chrome | _rest]}, :genes) when is_list(chrome) do
    config
    |> Map.put(:genes, length(chrome))
    |> validate(:chromes)
  end
  defp validate(config = %{input: [], chromes: chromes}, :chromes) when is_number(chromes) and chromes > 0 do
    validate(config, :eval_fn)
  end
  defp validate(config = %{input: input}, :chromes) do
    config
    |> Map.put(:chromes, length(input))
    |> validate(:eval_fn)
  end
  defp validate(config = %{eval_fn: fun}, :eval_fn) when is_function(fun) do
    config
  end
  defp validate(_config, param) do
    raise "Invalid or missing config param: #{param}."
  end
end
