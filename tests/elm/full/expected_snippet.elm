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
