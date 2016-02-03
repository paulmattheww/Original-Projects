Sub FormatCompleoVelocity()
    '' Be sure that you have separated bottles and cases BEFORE running; run separately
    Dim ws As Worksheet
    Set ws = Worksheets(1)
    ws.Rows("1:3").Delete Shift:=xlUp
    ws.Range("A1:I1000000").Sort Header:=xlYes, Key1:=Range("A1"), Order1:=xlDescending
      
End Sub






