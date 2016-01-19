Sub BuildRecountSheetsWave1()
    Dim ws As Worksheet, rg As Range, wave As Integer, i As Long

    For Each ws In ActiveWorkbook.Worksheets
        If ws.Name <> "Formatting Template" Then
            ws.Rows(1).Insert shift:=xlDown
            ws.Columns(1).Delete shift:=xlLeft
            ws.Cells(1, 1) = "Recount_" & ws.Name
            Sheets("Formatting Template").Range("A1:N50").Copy
            ws.Range("A1:N50").PasteSpecial xlPasteFormats
            Sheets("Formatting Template").Columns("A:N").Copy
            ws.Columns("A:N").PasteSpecial Paste:=xlPasteColumnWidths
            ws.Rows("3:15").RowHeight = 36
            Sheets("Formatting Template").Range("A2:N2").Copy
            ws.Range("A2:N2").PasteSpecial xlPasteValuesAndNumberFormats
            Sheets("Formatting Template").Range("G1:N1").Copy
            ws.Range("G1:N1").PasteSpecial xlPasteAll
            Sheets("Formatting Template").Range("G16:N16").Copy
            ws.Range("G16:N16").PasteSpecial xlPasteAll
            ws.PageSetup.Orientation = xlLandscape
            ws.Rows(17).PageBreak = xlPageBreakManual
            ws.Columns("O").PageBreak = xlPageBreakManual
        End If
    Next ws
    
End Sub






