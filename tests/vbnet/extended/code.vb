Imports System

' A full-line comment
Public Module Grains
    ''' <summary>
    ''' Calculate the number of grains on a square.
    ''' </summary>
    ''' <paramname="n"></param>
    ''' <returns></returns>
    Public Function Square(ByVal n As Integer) As ULong
        If n <= 0 OrElse n > 64 Then
            Throw New ArgumentOutOfRangeException(NameOf(n)) ' An inline comment with a preceding space
        End If

        Return If(n = 1, 1, 2 * Square(n - 1))
    End Function

    ''' <summary>
    ''' Calculate the total number of grains on the chessboard.
    ''' </summary>
    ''' <returns></returns>
    Public Function Total() As ULong
        Dim lTotal As ULong = 0

        For i = 1 To 64
            lTotal += Square(i)
        Next

        Return lTotal
    End Function
End Module
