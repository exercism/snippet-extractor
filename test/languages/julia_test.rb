require "test_helper"

class SnippetExtractor::Languages::JuliaTest < Minitest::Test
  def test_long_example
    code = <<~CODE
      # Types
      abstract type Pet end

      struct Dog <: Pet
          name::AbstractString
      end

      struct Cat <: Pet
          name::AbstractString
      end

      """
          encounter(a, b)

      Simulate an encounter between `a` and `b`.
      """
      encounter(a, b) = "$(name(a)) meets $(name(b)) and $(meets(a, b))."

      """

    CODE

    expected = <<~CODE
      abstract type Pet end

      struct Dog <: Pet
          name::AbstractString
      end

      struct Cat <: Pet
          name::AbstractString
      end

    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :julia)
  end

  def test_short_example
    code = <<~CODE
      """
          preptime(layers)

      Return the preparation time in minutes.
      """
      preptime(layers) = 2 * layers

      """
          remaining_time(current_time)

      Return the remaining oven time in minutes.
      """
      remaining_time(current_time) = 60 - current_time

      """
          total_working_time(layers, current_time)

      Return the total working time in minutes.
      """
      total_working_time(layers, current_time) = preptime(layers) + current_time
    CODE

    expected = <<~CODE
      """
          preptime(layers)

      Return the preparation time in minutes.
      """
      preptime(layers) = 2 * layers

      """
          remaining_time(current_time)

    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :julia)
  end
end
