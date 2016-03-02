Sub format_breakage()
    Dim ws As Worksheet
    
    For Each ws In ActiveWorkbook.Worksheets
        ws.Columns(1).Delete shift:=xlLeft
        ws.Columns("A:ZZ").Font.Size = 9
        ws.Columns("A:ZZ").AutoFit
        ws.Activate
        Range("A1").Activate
        Selection.AutoFilter
        ActiveWindow.DisplayGridlines = False
        ws.Columns("A:ZZ").AutoFit
        ws.Rows("1:9999").RowHeight = 11.5
        ws.Rows("1").Font.Bold = True
        ws.Range("A2").Select
        ActiveWindow.FreezePanes = True
        Application.ErrorCheckingOptions.BackgroundChecking = False
        ws.Cells.Replace "#N/A", "", xlWhole
        If ws.Name = "Summary" Then
            ws.Columns("A:H").Font.Size = 10
            ws.Columns("C").Font.Bold = True
            ws.Columns("D").Font.Bold = True
            ws.Columns("F").Font.Bold = True
            ws.Columns("G").Font.Bold = True
            ws.Columns("H").Font.Bold = True
            
            ws.Columns("A:AZ").AutoFit
            ws.Rows("1:9999").RowHeight = 12.5
            
            ws.Range("B2:B10").NumberFormat = "$#,##0"
            ws.Range("E2:E10").NumberFormat = "$#,##0"
            ws.Range("C2:D13").NumberFormat = "0.000%"
            ws.Range("F2:G13").NumberFormat = "0.000%"
            ws.Range("H2:H13").NumberFormat = "0.0%"
                        
        End If
    Next ws
