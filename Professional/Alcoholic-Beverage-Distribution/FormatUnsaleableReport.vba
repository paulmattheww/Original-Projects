Sub FormatUnsaleablesReport()
    Dim ws As Worksheet
    
    For Each ws In ActiveWorkbook.Worksheets
        ws.Columns(1).Delete shift:=xlLeft
        ws.Columns("A:ZZ").AutoFit
        ws.Activate
        ActiveWindow.DisplayGridlines = False
        Range("A1").Activate
        Selection.AutoFilter
    Next ws
    
End Sub
