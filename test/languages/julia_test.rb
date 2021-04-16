require "test_helper"

module SnippetExtractor
  module Languages
    class JuliaTest < Minitest::Test
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
              name(p::Pet)
          
          Return the name of the pet `p`.
          """
          name(p::Pet) = p.name
          
          # fallbacks
          meets(a::Pet, b::Pet) = "is cautious"
          meets(a::Pet, b) = "runs away"
          
          """
              meets(a, b)
          
          Return a string describing what happens when `a` and `b` meet.
          """
          meets(a, b) = "nothing happens"
          
          # specific types
          meets(a::Dog, b::Dog) = "sniffs"
          meets(a::Dog, b::Cat) = "chases"
          meets(a::Cat, b::Dog) = "hisses"
          meets(a::Cat, b::Cat) = "slinks"
        CODE

        expected = <<~CODE
          abstract type Pet end
          struct Dog <: Pet
              name::AbstractString
          end
          struct Cat <: Pet
              name::AbstractString
          end
          """
              encounter(a, b)

        CODE

        assert_equal expected, ExtractSnippet.(code, :julia)
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
        
        Return the remaining oven time in minutes.
        """
        CODE

        assert_equal expected, ExtractSnippet.(code, :julia)
      end
    end
  end
end
