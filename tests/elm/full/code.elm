module ComplexNumbers exposing
    ( Complex
    , abs
    , add
    , conjugate
    )

import Basics exposing (Float)
import List


{-| A complex number.

    It has a real and an imaginary part.

-}
type alias Complex =
    { real : Float, imaginary : Float }


-- Adds two complex numbers
add : Complex -> Complex -> Complex
add a b =
    { real = a.real + b.real
    , imaginary = a.imaginary + b.imaginary
    }


abs : Complex -> Float
abs z =
    sqrt (z.real ^ 2 + z.imaginary ^ 2)
