Sub format_all_workbooks()
    Dim wb As Workbook
    Dim ws As Worksheet
    Dim file_path As String
    Dim file As String
    Dim file_ext As String
    Dim folder_picker As FileDialog
    
    Application.ScreenUpdating = False
    Application.EnableEvents = False
    Application.Calculation = xlCalculationManual
    
    file_ext = "*.xl*"
    file_path = "N:\Operations Intelligence\Sales\Delivery Days\"
    file_name = Dir(file_path & file_ext)
    
    Do While file_name <> ""
      Set wb = Workbooks.Open(Filename:=file_path & file_name)
      
      For Each ws In ActiveWorkbook.Worksheets
        ws.Range("A:A, C:C, G:G, K:K, M:M, Q:Q, AA:AA").EntireColumn.Delete
        ws.Columns("A:ZZ").Font.Size = 9
        ws.Columns("A:ZZ").AutoFit
        ws.Activate
        Range("A1").Activate
        Selection.AutoFilter
        ActiveWindow.DisplayGridlines = False
        ws.Rows("1:999999").RowHeight = 11.5
        Application.ErrorCheckingOptions.BackgroundChecking = False
        ws.Cells.Replace "#N/A", "", xlWhole
    Next ws
    
    wb.Close SaveChanges:=True
    file_name = Dir
      
  Loop

End Sub


