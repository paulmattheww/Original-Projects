Sub format_off_day()
    Dim ws As Worksheet
    
    For Each ws In ActiveWorkbook.Worksheets
        ws.Columns(1).Delete shift:=xlLeft
        ws.Columns("A:I").Font.Size = 11
        ws.Columns("A:I").AutoFit
        ws.Activate
        Range("A1").Activate
        Selection.AutoFilter
        ActiveWindow.DisplayGridlines = False
        ws.Rows("1:100").RowHeight = 12.75
        ws.Rows("1").Font.Bold = True
        ws.Range("A2").Select
        Application.ErrorCheckingOptions.BackgroundChecking = False
        ws.Cells.Replace "#N/A", "", xlWhole
    Next ws
    
End Sub


