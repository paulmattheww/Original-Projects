Sub production_report_gather()

    Dim wb              As Workbook
    Dim ws              As Worksheet
    Dim file_name       As String
    Dim directory       As String
    Dim ext             As String
    Dim f_num           As Integer
    Dim my_files()      As String
    Dim t_wb            As Workbook
    Dim docs            As Workbook
    Dim file_list       As Object
    Dim target_path     As String
    Dim source          As Object
    Dim file            As Variant
    Dim last_row        As String
    Dim rng             As Range
    Dim cell            As Range
        
    Application.ScreenUpdating = False
    Application.EnableEvents = False

    target_path = "C:\Users\pmwash\Desktop\Disposable Docs\Testing Folder\Output\test.xlsx" ' Where the data is going
    
    directory = "C:\Users\pmwash\Desktop\Disposable Docs\Testing Folder\" ' Where the data is coming from
    
    Set source = CreateObject("Scripting.FileSystemObject")
    Set file_list = source.GetFolder(directory)
 
    For Each file In file_list.Files
        
        Set wb = Workbooks.Open(file)
        Set t_wb = Workbooks.Open(target_path)
        
        last_row = Sheets(1).Cells(Rows.Count, "A").End(xlUp).Row + 1
        
        wb.Sheets("Summary").Range("A1:B50").Copy
        t_wb.Activate
        t_wb.Worksheets(1).Range("A" & last_row).PasteSpecial Paste:=xlValues, Operation:=xlNone
        
        wb.Activate
        wb.Sheets("Summary").Range("D1:E53").Copy
        t_wb.Activate
        t_wb.Worksheets(1).Range("A" & last_row).PasteSpecial Paste:=xlValues, Operation:=xlNone
        
        wb.Activate
        wb.Sheets("Summary").Range("I1:J57").Copy
        t_wb.Activate
        t_wb.Worksheets(1).Range("A" & last_row).PasteSpecial Paste:=xlValues, Operation:=xlNone
        
        wb.Activate
        wb.Sheets("Summary").Range("L19:M26").Copy
        t_wb.Activate
        t_wb.Worksheets(1).Range("A" & last_row).PasteSpecial Paste:=xlValues, Operation:=xlNone
        
        t_wb.Worksheets(1).Range("C" & last_row & ":C" & last_row + 165) = wb.Name ' 49 + 52 = 101 + 56 = 157 + 8 = 165
        
            
        wb.Close False
        t_wb.Close True
    Next file
    
End Sub

' file_name = dir & "*.xl*"

' Set wb = Workbooks.Open(file_name)
'           Set ws = wb.Sheets("Summary")



'.PasteSpecial Paste:=xlValues, Operation:=xlNone, _
'            SkipBlanks:=False, Transpose:=True


