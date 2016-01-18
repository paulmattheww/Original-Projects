Sub BuildRecountSheetsWave1()
    Dim ws As Worksheet, rg As Range, wave As Integer
    
    For Each ws In ActiveWorkbook.Worksheets
        If ws.Name <> "Formatting Template" Then
            ws.Rows(1).Insert shift:=xlDown
            ws.Columns(1).Delete shift:=xlLeft
            ws.Cells(1, 1) = "Recount_" & ws.Name
            Sheets("Formatting Template").Range("A1:M50").Copy
            ws.Range("A1:M50").PasteSpecial xlPasteFormats
            Sheets("Formatting Template").Columns("A:M").Copy
            ws.Columns("A:M").PasteSpecial Paste:=xlPasteColumnWidths
            Sheets("Formatting Template").Range("1:50").RowHeight = ws.Range("1:50").RowHeight
        End If
    Next ws
    
End Sub
