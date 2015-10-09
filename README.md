###### gealts

Gealts is a very simple implementation of a genetic algorithm for solving math equality problems.
Gealts is based on [this work](http://arxiv.org/pdf/1308.4675.pdf) by Denny Hermawanto.
I'm planning to extend it for more general application purposes.

###### install

```elixir
defp deps do
	[{:gealts, github: "0010-IO/gealts"}]
end
```

###### basic usage

Start gealts first. A configuration map must be provided (please see "h Gealts.start" for options.)  
We'll try to solve *a + b + c = 10* here.


```elixir
iex(1)> Gealts.start(%{max_val: 10, 
                       genes: 3, 
                       chromes: 5, 
                       eval_fn: (fn [a, b, c] -> :erlang.abs((a + b + c) - 10) end)})
{:ok, #PID<0.87.0>}
```

View our initial population

```elixir
iex(2)> Gealts.population
[%Gealts.Chromosome{evaluation: 0, fitness: 0, probability: 0,
  values: [8, 9, 3]},
 %Gealts.Chromosome{evaluation: 0, fitness: 0, probability: 0,
  values: [3, 6, 1]},
 %Gealts.Chromosome{evaluation: 0, fitness: 0, probability: 0,
  values: [4, 5, 6]},
 %Gealts.Chromosome{evaluation: 0, fitness: 0, probability: 0,
  values: [0, 0, 8]},
 %Gealts.Chromosome{evaluation: 0, fitness: 0, probability: 0,
  values: [5, 5, 1]}]
```

Perform 200 iterations, modifying the population in the process.

```elixir
iex(3)> Gealts.iterate(200)
:ok
```

View population after 200 iterations.

```elixir
iex(4)> Gealts.population
[%Gealts.Chromosome{evaluation: 0, fitness: 1.0,
  probability: 0.35593220338983056, values: [2, 5, 3]},
 %Gealts.Chromosome{evaluation: 0, fitness: 1.0,
  probability: 0.35593220338983056, values: [2, 5, 3]},
 %Gealts.Chromosome{evaluation: 2, fitness: 0.3333333333333333,
  probability: 0.11864406779661017, values: [0, 5, 3]},
 %Gealts.Chromosome{evaluation: 1, fitness: 0.5,
  probability: 0.35593220338983056, values: [1, 5, 3]},
 %Gealts.Chromosome{evaluation: 0, fitness: 1.0,
  probability: 0.35593220338983056, values: [2, 5, 3]}]
```

Best chromosome.

```elixir
iex(5)> Gealts.best
%Gealts.Chromosome{evaluation: 0, fitness: 1.0,
 probability: 0.35593220338983056, values: [2, 5, 3]}
```

Possible solution to *a + b + c = 10* is *2 + 5 + 3 = 10*

See source as well as repl for documentation.