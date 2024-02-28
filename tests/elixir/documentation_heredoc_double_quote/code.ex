defmodule Maths do
  @moduledoc """
  A module that implements functions for performing simple
  mathematic calculations

  ```elixir
    @doc "Add two numbers together"
    def add(left, right) do
      # Add two numbers together
      left + right
    end
  end
  ```
  """

  @typedoc """
      iex> 1 + * 1
      1
  """

  @type t :: any()

  @doc """
  Add two numbers together
  """
  def add(left, right) do
    # Add two numbers together
    left + right
  end
end
