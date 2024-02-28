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

