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
            
            ws.Range("A2").EntireRow.Insert
            ws.Range("A6").EntireRow.Insert
            
            
            Dim whse As Long, drv As Long, current As Long
            Dim whsex As Long, drvx As Long, ytd As Long
            
            whse = ws.Range("B3").Value
            drv = ws.Range("B4").Value
            whsex = ws.Range("B6").Value
            drvx = ws.Range("B7").Value
            
            current = whse + drv
            ytd = whsx + drvx
            
            ws.Range("B2").Select
            ActiveCell.FormulaR1C1 = current
            ws.Range("B6").Select
            ActiveCell.FormulaR1C1 = ytd
            
            
            Dim whsely As Long, drvly As Long, currently As Long
            Dim whselyx As Long, drvlyx As Long, ytdly As Long
            
            whsely = ws.Range("E3").Value
            drvly = ws.Range("E4").Value
            whselyx = ws.Range("E6").Value
            drvlyx = ws.Range("E7").Value
            
            currently = whsely + drvly
            ytdly = whslyx + drvlyx
            
            ws.Range("E2").Select
            ActiveCell.FormulaR1C1 = currently
            ws.Range("E6").Select
            ActiveCell.FormulaR1C1 = ytdly
            
            
            
            ws.Range("B2:B7").NumberFormat = "$#,##0"
            ws.Range("C2:D10").NumberFormat = "0.00%"
            ws.Range("F2:H10").NumberFormat = "0.00%"
                        
        End If
    Next ws
    
End Sub







