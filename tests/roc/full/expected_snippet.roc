valid : Str -> Bool
valid = \number ->
    when toDigits number is
        Ok digits if List.len digits > 1 ->
            mapEveryOtherBackwards digits \digit ->
                product = digit * 2
                if product < 10 then product else product - 9
            |> List.sum
            |> Num.isMultipleOf 10

