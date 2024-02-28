defmodule Maths do
  @moduledoc ~S'''
  A module that implements functions for performing simple
  mathematic calculations
  '''

  @typedoc ~S'''
      iex> 1 + * 1
      1
  '''

  @type t :: any()

  @doc ~S'''
  Add two numbers together
  '''
  def add(left, right) do
    # Add two numbers together
    left + right
  end
end
