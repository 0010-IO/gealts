defmodule Gealts.MathUtils do
	@moduledoc """
	Math related functions.
  """

	@doc """
	A shorthand for :random.uniform
  """
	@spec random() :: float
	def random do
		:random.uniform
	end

	@doc """
	Calls :random.uniform n number of times,
	retuns a list of results.
  """
	@spec random_list(non_neg_integer) :: [float]
	def random_list(n) do
		for _ <- 1..n, do: random
	end

	@doc """
	Random integer in range n, m
  """
	@spec random_int(non_neg_integer, non_neg_integer) :: non_neg_integer
	def random_int(n, m) do
		:crypto.rand_uniform(n, m)
	end

	@doc """
	Similar to Gealts.MathUtils.random_list/1.
	Takes n, m; list length and max ceiling respecitvely.
	Calls Gealts.MathUtils.random_int(0, m) n number of times,
	returns a list of results.
  """
	@spec random_values_list(non_neg_integer, non_neg_integer) :: [non_neg_integer]
	def random_values_list(n, max) do
		for _ <- 1..n, do: random_int(0, max)
	end
	@doc """
	Like Gealts.MathUtils.random_values_list/2, only
	uses "min" parameter as the minimum value when calling
	Gealts.MathUtils.random_int/2.
  """
	@spec random_values_list(non_neg_integer, non_neg_integer, non_neg_integer) :: [non_neg_integer]
	def random_values_list(n, min, max) do
		for _ <- 1..n, do: random_int(min, max)
	end
end
