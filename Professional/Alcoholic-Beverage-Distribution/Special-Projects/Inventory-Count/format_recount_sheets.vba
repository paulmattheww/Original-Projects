Sub BuildRecountSheets()
    Dim ws As Worksheet, rg As Range
    
    For Each ws In ActiveWorkbook.Worksheets
        Set rg = ws.Rows("1:1").Select
        Selection.Insert Shift:=xlUp
    Next ws
        
End Sub
