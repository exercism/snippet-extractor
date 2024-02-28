defmodule Maths do
  @moduledoc ~s'''
  A module that implements functions for performing simple
  mathematic calculations
  '''

  @typedoc ~s'''
      iex> 1 + * 1
      1
  '''

  @type t :: any()

  @doc ~s'''
  Add two numbers together
  '''
  def add(left, right) do
    # Add two numbers together
    left + right
  end
end
