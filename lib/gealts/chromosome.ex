defmodule Gealts.Chromosome do
  @moduledoc """
  A single chromosome.
  A chromosome has the following properties:

    values      - A list of values to be evaluated by eval_fun
                  This is either randomly generated input or input
                  provided directly by the user.
    evaluation  - Result of eval_fun(values).
    fitness     - Result of fitness_fun(evaluation).
    probability - Probabiliyt of single chromosome gen x 
                  to be chosen as part of population gen z.
  """

  defstruct values: [], evaluation: 0, fitness: 0, probability: 0

  @type t :: %Gealts.Chromosome{}
end
