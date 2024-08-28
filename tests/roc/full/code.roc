## This code is the solution to the Luhn exercise with a few extra comments
## added to the top few lines, to test the snippet-extractor.
## We expect all comments to be stripped away, as well as the module line:
module [valid]

## The valid function is the only function exported by
## this module
valid : Str -> Bool
valid = \number ->
    when toDigits number is
        Ok digits if List.len digits > 1 ->
            mapEveryOtherBackwards digits \digit ->
                product = digit * 2
                if product < 10 then product else product - 9
            |> List.sum
            |> Num.isMultipleOf 10

        _ -> Bool.false

toDigits : Str -> Result (List U16) _
toDigits = \number ->
    help = \input, digits ->
        when input is
            [] -> Ok digits
            [byte, .. as rest] if byte == ' ' -> help rest digits
            [byte, .. as rest] if '0' <= byte && byte <= '9' ->
                # convert to U16 to prevent an overflow when summing up the digits
                digit = byte - '0' |> Num.toU16
                help rest (List.append digits digit)

            _ -> Err IllegalCharacter
    help (Str.toUtf8 number) []

mapEveryOtherBackwards : List a, (a -> a) -> List a
mapEveryOtherBackwards = \list, func ->
    help = \state, input ->
        when input is
            [.. as rest, x, y] ->
                List.append state y
                |> List.append (func x)
                |> help rest

            [x] -> List.append state x
            [] -> state

    help [] list
    |> List.reverse
