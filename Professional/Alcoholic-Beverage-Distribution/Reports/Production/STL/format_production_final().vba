Sub format_production()
    Dim ws As Worksheet
    
    For Each ws In ActiveWorkbook.Worksheets
        ws.Columns("A:ZZ").Font.Size = 9
        ws.Activate
        Range("A1").Activate
        Selection.AutoFilter
        
        ActiveWindow.DisplayGridlines = False
        ws.Columns("A:ZZ").AutoFit
        ws.Rows("1:9999").RowHeight = 11.5
        ws.Rows("1").Font.Bold = True
        
        ws.Cells.Replace "#N/A", "", xlWhole
        
        If ws.Name = "Monthly Summary" Then
            ws.Columns("A:M").Font.Size = 10
            
            ws.Columns("A:AZ").AutoFit
            ws.Rows("1:9999").RowHeight = 12.5
            
            ws.Range("B2:M17").NumberFormat = "#,##0"
                        
        End If
    Next ws
    
End Sub

