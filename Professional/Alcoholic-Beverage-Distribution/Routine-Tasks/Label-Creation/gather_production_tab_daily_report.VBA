Sub gather_production_tab_daily_report_stl()

    ' Start with a blank spreadsheet with three columns Key Value Date
    ' Copy Daily Reports to a safe place; delete afterwards (from N:\Daily Report\2016)
    ' Ensure target ws is cleared

    Dim wb              As Workbook
    Dim ws              As Worksheet
    Dim file_name       As String
    Dim directory       As String
    Dim t_wb            As Workbook
    Dim docs            As Workbook
    Dim file_list       As Object
    Dim target_path     As String
    Dim source          As Object
    Dim file            As Variant
    Dim last_row        As String
        
    Application.ScreenUpdating = False
    Application.EnableEvents = False
    
    target_path = "C:\Users\pmwash\Desktop\Disposable Docs\Production Data\Output\process_output.xlsx" ' Where the data is going
    
    directory = "C:\Users\pmwash\Desktop\Disposable Docs\Production Data\" ' Where the data is coming from
    
    Set source = CreateObject("Scripting.FileSystemObject")
    Set file_list = source.GetFolder(directory)
 
    For Each file In file_list.Files
        
        Set wb = Workbooks.Open(file)
        Set t_wb = Workbooks.Open(target_path)
        
        last_row = Cells(Rows.Count, "A").End(xlUp).Row + 1
        
        wb.Activate
        wb.Sheets("Production").Range("C1:R79").Copy
        t_wb.Activate
        t_wb.Worksheets(1).Range("A" & last_row).PasteSpecial Paste:=xlValues, SkipBlanks:=False
        
        t_wb.Worksheets(1).Range("Q" & last_row & ":Q" & last_row + 78) = wb.Name
        
        t_wb.Worksheets(1).Range("R" & last_row).Select
        Selection = "1"
        Selection.DataSeries Rowcol:=xlColumns, Type:=xlLinear, Date:=xlDay, Step:=1, Stop:=79, Trend:=False
        
        
        wb.Close False
        t_wb.Close True
        
    Next file
   
    
End Sub















Sub gather_production_tab_daily_report_kc()

    ' Start with a blank spreadsheet with three columns Key Value Date
    ' Copy Daily Reports to a safe place; delete afterwards (from N:\Daily Report\2016)
    ' Ensure target ws is cleared

    Dim wb              As Workbook
    Dim ws              As Worksheet
    Dim file_name       As String
    Dim directory       As String
    Dim t_wb            As Workbook
    Dim docs            As Workbook
    Dim file_list       As Object
    Dim target_path     As String
    Dim source          As Object
    Dim file            As Variant
    Dim last_row        As String
        
    Application.ScreenUpdating = False
    Application.EnableEvents = False
    
    target_path = "C:\Users\pmwash\Desktop\Disposable Docs\Production Data\Output\process_output.xlsx" ' Where the data is going
    
    directory = "C:\Users\pmwash\Desktop\Disposable Docs\Production Data\" ' Where the data is coming from
    
    Set source = CreateObject("Scripting.FileSystemObject")
    Set file_list = source.GetFolder(directory)
 
    For Each file In file_list.Files
        
        Set wb = Workbooks.Open(file)
        Set t_wb = Workbooks.Open(target_path)
        
        last_row = Cells(Rows.Count, "A").End(xlUp).Row + 1
        
        wb.Activate
        wb.Sheets("Production").Range("C1:R59").Copy
        t_wb.Activate
        t_wb.Worksheets(1).Range("A" & last_row).PasteSpecial Paste:=xlValues, SkipBlanks:=False
        
        t_wb.Worksheets(1).Range("Q" & last_row & ":Q" & last_row + 58) = wb.Name
        
        t_wb.Worksheets(1).Range("R" & last_row).Select
        Selection = "1"
        Selection.DataSeries Rowcol:=xlColumns, Type:=xlLinear, Date:=xlDay, Step:=1, Stop:=59, Trend:=False
        
        
        wb.Close False
        t_wb.Close True
        
    Next file
   
    
End Sub


