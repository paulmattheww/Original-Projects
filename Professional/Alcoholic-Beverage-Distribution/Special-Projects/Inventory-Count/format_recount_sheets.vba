Sub BuildRecountSheetsWave1()
    Dim ws As Worksheet, rg As Range, wave As Integer
    
    For Each ws In ActiveWorkbook.Worksheets
        If ws.Name <> "Formatting Template" Then
            ws.Rows(1).Insert shift:=xlDown
            ws.Columns(1).Delete shift:=xlLeft
            ws.Cells(1, 1) = "Recount_" & ws.Name
            Sheets("Formatting Template").Range("A1:M50").Copy
            ws.Range("A1:M50").PasteSpecial xlPasteFormats
            
        End If
    Next ws
    
End Sub
