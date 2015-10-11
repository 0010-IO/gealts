defmodule GealtsTest do
  use ExUnit.Case
  doctest Gealts

  test "Simple equation gets solved correctly." do

    # Note: Test might fail since we might not be
    #       able to find a satisfactory answer
    #       within 1k iterations.

    eval_fn = (fn [a, b, c, d] ->
      :erlang.abs((a + 2 * b + 3 * c + 4 * d) - 30)
    end)

    input = [
       [12, 05, 23, 08],
       [02, 21, 18, 03],
       [10, 04, 13, 14],
       [20, 01, 10, 06],
       [01, 04, 13, 19],
       [20, 05, 17, 01]
    ]

    Gealts.start(%{input: input, max_val: 31, eval_fn: eval_fn})
    Gealts.iterate(1000)
    assert eval_fn.(Gealts.best().values) == 0
  end
end
