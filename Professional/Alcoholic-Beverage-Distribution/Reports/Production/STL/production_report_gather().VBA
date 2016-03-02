Sub production_report_gather()

    ' Start with a blank spreadsheet with three columns Key Value Date
    ' Copy Daily Reports to a safe place; delete afterwards (from N:\Daily Report\2016)

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
    
    ' Ensure key value date index columns are there, and all else is cleared
    target_path = "C:\Users\pmwash\Desktop\Disposable Docs\Testing Folder\Output\input_production_report.xlsx" ' Where the data is going
    
    directory = "C:\Users\pmwash\Desktop\Disposable Docs\Testing Folder\" ' Where the data is coming from
    
    Set source = CreateObject("Scripting.FileSystemObject")
    Set file_list = source.GetFolder(directory)
 
    For Each file In file_list.Files
        
        Set wb = Workbooks.Open(file)
        Set t_wb = Workbooks.Open(target_path)
        
        last_row = Cells(Rows.Count, "A").End(xlUp).Row + 1 ' Sheets(1).Cells(Rows.Count, "A").End(xlUp).Row + 1
        
        wb.Activate
        wb.Sheets("Summary").Range("I5:J57").Copy
        t_wb.Activate
        t_wb.Worksheets(1).Range("A" & last_row).PasteSpecial Paste:=xlValues, SkipBlanks:=False
        
        t_wb.Worksheets(1).Range("C" & last_row & ":C" & last_row + 54) = wb.Name
        
        t_wb.Worksheets(1).Range("D" & last_row).Select
        Selection = "1"
        Selection.DataSeries Rowcol:=xlColumns, Type:=xlLinear, Date:=xlDay, Step:=1, Stop:=53, Trend:=False
        
        
        
        last_row = Cells(Rows.Count, "A").End(xlUp).Row + 1
        
        wb.Activate
        wb.Sheets("Summary").Range("L19:M26").Copy
        t_wb.Activate
        t_wb.Worksheets(1).Range("A" & last_row).PasteSpecial Paste:=xlValues, SkipBlanks:=False
        
        t_wb.Worksheets(1).Range("C" & last_row & ":C" & last_row + 7) = wb.Name
        
        t_wb.Worksheets(1).Range("D" & last_row).Select
        Selection = "1"
        Selection.DataSeries Rowcol:=xlColumns, Type:=xlLinear, Date:=xlDay, Step:=1, Stop:=53, Trend:=False
        
        wb.Close False
        t_wb.Close True
        
    Next file
    
    
    For Each file In file_list.Files
        
        Set wb = Workbooks.Open(file)
        Set t_wb = Workbooks.Open(target_path)
        
        last_row = Cells(Rows.Count, "A").End(xlUp).Row + 1
    
        wb.Activate
        wb.Sheets("Summary").Range("A5:B50").Copy
        t_wb.Activate
        t_wb.Worksheets(1).Range("A" & last_row).PasteSpecial Paste:=xlValues, SkipBlanks:=False
        
        t_wb.Worksheets(1).Range("C" & last_row & ":C" & last_row + 48) = wb.Name
        
        t_wb.Worksheets(1).Range("D" & last_row).Select
        Selection = "54"
        Selection.DataSeries Rowcol:=xlColumns, Type:=xlLinear, Date:=xlDay, Step:=1, Stop:=102, Trend:=False
        
        wb.Close False
        t_wb.Close True
        
    Next file
    
    
    For Each file In file_list.Files
        
        Set wb = Workbooks.Open(file)
        Set t_wb = Workbooks.Open(target_path)
        
        last_row = Cells(Rows.Count, "A").End(xlUp).Row + 1
        
        wb.Activate
        wb.Sheets("Summary").Range("D5:E53").Copy
        t_wb.Activate
        t_wb.Worksheets(1).Range("A" & last_row).PasteSpecial Paste:=xlValues, SkipBlanks:=False
        
        t_wb.Worksheets(1).Range("C" & last_row & ":C" & last_row + 48) = wb.Name
        
        t_wb.Worksheets(1).Range("D" & last_row).Select
        Selection = "103"
        Selection.DataSeries Rowcol:=xlColumns, Type:=xlLinear, Date:=xlDay, Step:=1, Stop:=151, Trend:=False
        
        wb.Close False
        t_wb.Close True
        
    Next file
    
End Sub
