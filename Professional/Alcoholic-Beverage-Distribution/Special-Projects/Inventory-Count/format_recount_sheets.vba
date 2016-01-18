Sub BuildRecountSheetsWave1()
    Dim ws As Worksheet, rg As Range, wave As Integer
    
    For Each ws In ActiveWorkbook.Worksheets
        If ws.Name <> "Formatting Template" Then
            ws.Rows(1).Insert shift:=xlDown
            ws.Columns(1).Delete shift:=xlLeft
        End If
    Next ws
    
End Sub
