Public Module Grains
    Public Function Square(ByVal n As Integer) As ULong
        If n <= 0 OrElse n > 64 Then
            Throw New ArgumentOutOfRangeException(NameOf(n))
        End If

        Return If(n = 1, 1, 2 * Square(n - 1))
    End Function

    Public Function Total() As ULong
