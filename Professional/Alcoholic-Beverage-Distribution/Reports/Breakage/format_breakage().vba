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
            ws.Columns("A:AZ").AutoFit
            ws.Rows("1:9999").RowHeight = 12.5
            
            ws.Range("A2").EntireRow.Insert shift:=xlUp
            ws.Range("A7").EntireRow.Insert shift:=xlUp
            
            
            Dim whse As Long, drv As Long, current As Long
            Dim whse_ytd As Long, drv_ytd As Long, ytd As Long
            
            whse = ws.Range("B3").Value
            drv = ws.Range("B4").Value
            whse_ytd = ws.Range("B8").Value
            drv_ytd = ws.Range("B9").Value
            
            current = whse + drv
            ytd = whse_ytd + drv_ytd
            
            ws.Range("B2").Select
            ActiveCell.FormulaR1C1 = current
            ws.Range("B7").Select
            ActiveCell.FormulaR1C1 = ytd
            
            
            Dim whse_ly As Long, drv_ly As Long, current_ly As Long
            Dim whse_ly_ytd As Long, drv_ly_ytd As Long, ytd_ly As Long
            
            whse_ly = ws.Range("E3").Value
            drv_ly = ws.Range("E4").Value
            whse_ly_ytd = ws.Range("E8").Value
            drv_ly_ytd = ws.Range("E9").Value
            
            current_ly = whse_ly + drv_ly
            ytd_ly = whse_ly_ytd + drv_ly_ytd
            
            ws.Range("E2").Select
            ActiveCell.FormulaR1C1 = current_ly
            ws.Range("E7").Select
            ActiveCell.FormulaR1C1 = ytd_ly
            
            
            
            ws.Range("B2:B10").NumberFormat = "$#,##0"
            ws.Range("E2:E10").NumberFormat = "$#,##0"
            ws.Range("C2:D13").NumberFormat = "0.0000%"
            ws.Range("F2:H13").NumberFormat = "0.0000%"
                        
        End If
    Next ws
    
End Sub














