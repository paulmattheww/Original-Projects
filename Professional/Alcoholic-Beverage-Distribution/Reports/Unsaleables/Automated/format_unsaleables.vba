Sub FormatUnsaleablesReport()

    ' Must first run unsaleables report, should be automatic
    ' Query is not automatic as of 5/12/16
    ' AS400 -> Powershell -> R -> VBA -> SMTP -> consumer
    
    'Option Explicit
    'On Error Resume Next

    Dim path    As String
    Dim ws      As Worksheet
    Dim yr      As String
    Dim mnth    As String
    Dim day     As String
    Dim Now     As String
    
    Application.ScreenUpdating = False
    Application.EnableEvents = False
    
    Now = Date
    
    yr = Format(Now, "YYYY")
    mnth = Format(Now, "MMMM")
    day = Format(Now, "dd")

    ' old "C:\Users\pmwash\Desktop\R_files\Data Output\"
    path = "N:\Operations Intelligence\Monthly Reports\Unsaleables\Data\" & mnth & "_" & day & "_" & yr & "_unsaleables_returns_dumps.xlsx"
    
    Workbooks.Open Filename:=path
       
    For Each ws In ActiveWorkbook.Worksheets
    
        ws.Columns(1).Delete shift:=xlLeft
        ws.Columns("A:ZZ").Font.Size = 9
        ws.Columns("A:ZZ").AutoFit
        ws.Activate
        Range("A1").Activate
        Selection.AutoFilter
        ActiveWindow.DisplayGridlines = False
        ws.Columns("A:ZZ").AutoFit
        ws.Rows("1:999999").RowHeight = 11.5
        Application.ErrorCheckingOptions.BackgroundChecking = False
        ws.Cells.Replace "#N/A", "", xlWhole
        
    Next ws
    
    ActiveWorkbook.ActiveSheet.Activate
    ActiveWorkbook.Save
    
End Sub

'xlApp.Run "FormatUnsaleablesReport"


