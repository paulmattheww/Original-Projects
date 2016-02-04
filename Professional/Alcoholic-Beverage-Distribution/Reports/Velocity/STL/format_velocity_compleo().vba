Sub FormatCompleoVelocity()
    '' Be sure that you have separated bottles and cases BEFORE running
    '' Be sure there are three rows before header row
    Dim ws As Worksheet, Rng As Range, cell As Range
    
    Set ws = Worksheets(1)
    
    ws.Rows("1:3").Delete Shift:=xlUp
    
    ' ws.Range("A1:I1000000").Sort Header:=xlYes, Key1:=Range("A1"), Order1:=xlDescending
    
    Dim Arr As Variant
    Dim i As Long
    Arr = Array(xlCellTypeBlanks, xlCellTypeConstants)
    For i = 0 To UBound(Arr)
    Set Rng = Range("A2:A1000000").SpecialCells(Arr(i), 22)
        If Not Rng Is Nothing Then
            Rng.EntireRow.Delete
        End If
    Next i
    
    ws.Columns("A:H").Font.Size = 9
    ws.Columns("A:H").AutoFit
    ActiveWindow.DisplayGridlines = False
    
    Set Rng = Range("A1:H1000000")
    Set cell = Range("C1")
    
    Rng.Sort Key1:=cell, Order1:=xlDescending, Header:=xlYes
    
    ws.Columns(1).NumberFormat = "####"
    ws.Columns(3).NumberFormat = "####"
    ws.Columns(4).NumberFormat = "####"
    ws.Columns(5).NumberFormat = "####"
    ws.Columns(6).NumberFormat = "####"
    ws.Columns(7).NumberFormat = "####"
    ws.Columns(8).NumberFormat = "####"
    
End Sub





