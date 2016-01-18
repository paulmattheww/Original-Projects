
Option Explicit

'PREPARE FOR NEW RUN --   Clears all the old data.

'BEFORE STARTING
    'Make sure Data Entry has a col A which is KEY (VERIFY THIS IS THE ONE THAT GETS DELETED)
    'Clear out the Control Log sheet
    'Make sure there are no hidden sheets
    'make sure the filters are off in all sheets
    
    
    'AFTER RUN
    ' Check Analysis formulas G and H
    ' Send Step 1 to Paul, Christina and Amy
    


'CHECKS - Known issues
    'Analysis tab:  Total Case is G and total Bottle is H.  Sometimes shifts to F and G.   Fix manually if needed.


Sub StartOver()
'ONLY RUN THIS ONCE!!!!!!!!! Or, Step1 sheet col A will be deleted too many times.

'Clear out the raw sheet for prep.
    Sheets("Raw").Select
    Range("M3").Select
    Range(Selection, ActiveCell.SpecialCells(xlLastCell)).Select
    Selection.ClearContents
'Turn off filter on DataEntry
    Cells.Select
    Selection.AutoFilter
    Range("C2").Select
'Clear out Step one sheet.
    Sheets("Step1").Select
    Range("A2").Select
    Range(Selection, ActiveCell.SpecialCells(xlLastCell)).Select
    Selection.ClearContents
'Delete col A in STEP1 sheet.  It was the key
    Sheets("Step1").Select
    If Cells(1, 1) = "KEY" Then
        Columns("A:A").Select
        Selection.Delete Shift:=xlToLeft
    End If
    Range("A1").Select
'clear out all the wave sheets
    ClearAllWaves
'Clear out the collections sheet NOT COMPLETE

'Clear the Data Entry Sheet.
    Sheets("DataEntry").Select
    Range("A2:Y1154").Select
    Selection.ClearContents
    Range("T4").Select
'Clear ALL stuff off the Analysis Sheet
    Sheets("Analysis").Select
    Cells.Select
    Selection.Delete Shift:=xlUp
    Range("H6").Select


'NOTES:  QA
    'MAKE SURE Step1 sheet col 1 is "location_id" not key or something else.

End Sub



'PASTE IN THE DATA FROM SQL NOW.   INTO RAW SHEET STARTING AT CELL A2

Sub PrepareSheetOne() 'RUN FIRST (REDO ATP) 12-9-15
    Sheets("RAW").Select

'AFTER PASTING IN THE DATA FROM SQL, RUN THIS TO GET "RAW" sheet ready to use.

'Clear out the existing data in RAW   (IS Z RIGHT????  CHECKUP BS)
    ActiveWindow.SmallScroll Down:=-3
      Range("M3:Z20000").Select
    Range(Selection, ActiveCell.SpecialCells(xlLastCell)).Select
    Selection.Delete Shift:=xlUp

'Find the count of rows
Dim Lastrow As Long
With ActiveSheet
        Lastrow = .Cells(.Rows.Count, "A").End(xlUp).Row
    End With
   
'Put the formula back into Col X for which Book to use.  IN THE RAW DATA  (PROBLEM BS CHECK THIS)
Cells(2, 24) = "=VLOOKUP(E2,Reference!A:B,2,FALSE)"
'Cells(2, 24).Select
'Selection.Copy
'Range("X3:X" & Lastrow).Select
'Selection.PasteSpecial Paste:=xlPasteFormulas, Operation:=xlNone, _
'        SkipBlanks:=False, Transpose:=False
'Application.CutCopyMode = False


   
'copy down formula's in cols  M to W
    Range("M2:Z2").Select
    Selection.Copy
    Range("M3:M" & Lastrow).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Range("M1").Select
    
    'Replace NULL in Vintage column
    Columns("K:K").Select
    Cells.Replace What:="NULL", Replacement:="", LookAt:=xlPart, SearchOrder _
        :=xlByRows, MatchCase:=False, SearchFormat:=False, ReplaceFormat:=False

'Trim col J, there are spaces in the Bottle_sizes
    Dim i As Long
    For i = 2 To Lastrow
        Cells(i, 10) = LTrim(RTrim(Cells(i, 10)))
    Next i
 'Replace NA with 1 For Book Column  'DEFAULTS ANy ITEM THAT DIDN"T HAVE A COUNT SHEET TO SHEET ONE.
    Columns("X:X").Select
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    Columns("X:X").Select
    Selection.Replace What:="#N/A", Replacement:="1", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, _
        ReplaceFormat:=False
    Cells(1, 1).Select
    

End Sub

Sub BuildWaveSheets()  'RUN SECOND   CHANGED ATP 12-9-15  Populates the Step1Sheet (I think)

' Create's all the Wave sheets.

'Sheet one "RAW" must have formula's all for each input row.  CHECK THAT.
    
    
    'copy over the data from RAW to STEP1.
    Sheets("RAW").Select
    Columns("M:Z").Select
    Selection.Copy
    Sheets("Step1").Select
    Cells(1, 1).Activate
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Range("F5").Select
    Application.CutCopyMode = False
    
 'Sort on the rank in STEP1 Sheet.
    Sheets("Step1").Select
    Cells.Select
    ActiveWorkbook.Worksheets("Step1").Sort.SortFields.Clear
    ActiveWorkbook.Worksheets("Step1").Sort.SortFields.Add Key:=Range("I2:I1110") _
        , SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:=xlSortNormal
    With ActiveWorkbook.Worksheets("Step1").Sort
        .SetRange Range("A1:N1110")
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
'Populate the WAVE sheets.
    Dim WaveNum As Integer
    Dim StartRow As Integer
    Dim EndRow As Integer
    Dim Z As Integer  'junk counter.


Sheets("Step1").Select

'COPy OVER THE WAVE SHEETS
StartRow = 2
EndRow = 2
For WaveNum = 1 To 10
    Sheets("Step1").Select
    
    'Get the range for this wave in "Step1"
    Do While ((Cells(EndRow, 9) < (WaveNum * 20) + 1) And (Len(Cells(EndRow, 9)) > 0))
        EndRow = EndRow + 1
       
    Loop
     EndRow = EndRow - 1
     'Copy over this data set
    Range("A" & StartRow & ":N" & EndRow).Select
    Selection.Copy
    Sheets("Wave" & WaveNum).Select
    Range("A2").Select
    ActiveSheet.Paste
    Range("C8").Select
    Sheets("Step1").Select
    'Debug.Print WaveNum & "  " & StartRow & "  " & EndRow
    StartRow = EndRow + 1
    EndRow = StartRow

Next WaveNum

Sheets("Step1").Select
Cells(1, 1).Select

End Sub


'Run THIRD- Make the data entry sheet now.  "DATAENTRY"  (ADDS COL 1 To "STEP1" tab)
Sub MakeDataEntrySheet()


    Dim Lastrow As Integer
'Get the lastrow EXPECTED.
    Sheets("RAW").Select
    With ActiveSheet
        Lastrow = .Cells(.Rows.Count, "A").End(xlUp).Row
    End With
    Sheets("DataEntry").Select

'Clear the Data Entry Sheet
    Sheets("DataEntry").Select
    Range("A2").Select
    Range(Selection, ActiveCell.SpecialCells(xlLastCell)).Select
    Selection.ClearContents
    Range("A1").Select
    

'Copy over the columns
    Sheets("Step1").Select
    'Location  A/B --  Item Number B/C  --  Description  C/D  --  QPC D/E  --    'Vintage  E/F
    Sheets("Step1").Select
    Columns("A:E").Select
    Application.CutCopyMode = False
    Selection.Copy
    Sheets("DataEntry").Select
    Columns("B:F").Select
    ActiveSheet.Paste
    Range("D2").Select
    Cells(1, 2) = "Loc"
    Cells(1, 3) = "Item #"
    Cells(1, 4) = "Desc"
    Cells(1, 5) = "QPC"
    Cells(1, 6) = "Vintage"
    
    'Case  F/0J
    Sheets("Step1").Select
    Columns("F:F").Select
    Selection.Copy
    Sheets("DataEntry").Select
    Columns("J:J").Select
    ActiveSheet.Paste
    Cells(1, 10) = "Case"
    'BTL  G/K
    Sheets("Step1").Select
    Columns("G:G").Select
    Selection.Copy
    Sheets("DataEntry").Select
    Columns("K:K").Select
    ActiveSheet.Paste
    Cells(1, 11) = "BTL"
  
    'PercentInventory  J/V  Not even sure we need this
    Sheets("Step1").Select
    Columns("J:J").Select
    Selection.Copy
    Sheets("DataEntry").Select
    Columns("V:V").Select
    ActiveSheet.Paste
    
    'Rank I to X
    Sheets("Step1").Select
    Columns("I:I").Select
    Selection.Copy
    Sheets("DataEntry").Select
    Columns("X:X").Select
    ActiveSheet.Paste
    

    'Size M to S
    Sheets("Step1").Select
    Columns("M:M").Select
    Selection.Copy
    Sheets("DataEntry").Select
    Columns("S:S").Select
    ActiveSheet.Paste

    'Cost N to T
    Sheets("Step1").Select
    Columns("N:N").Select
    Selection.Copy
    Sheets("DataEntry").Select
    Columns("T:T").Select
    ActiveSheet.Paste

    'PercentSales  to  W
    Sheets("Step1").Select
    Columns("K:K").Select
    Selection.Copy
    Sheets("DataEntry").Select
    Columns("W:W").Select
    ActiveSheet.Paste

    'Book L to N
    Sheets("Step1").Select
    Columns("L:L").Select
    Selection.Copy
    Sheets("DataEntry").Select
    Columns("N:N").Select
    ActiveSheet.Paste
    'Set the format for the book column  ("Range") is the name of the col now
    Cells(1, 14) = "Book"
    Range("M1").Select
    Selection.Copy
    Range("N1").Select
    Selection.PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, _
        SkipBlanks:=False, Transpose:=False
    Application.CutCopyMode = False


'Set the key value in Column A
    
    Cells(2, 1) = "=CONCATENATE(C2,B2)"
    Range("A2").Select
    Selection.Copy
    Range("A3:A" & Lastrow).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Range("A4").Select
    'Copy / Paste values for the keys
    Columns("A:A").Select
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    Range("A2").Select

'Formulas
    'Col I Total BTL Counted
    Sheets("DataEntry").Select
    Cells(2, 9) = "=(E2*G2)+H2"
    Range("I2").Select
    Selection.Copy
    Range("I3:I" & Lastrow).Select
    Selection.PasteSpecial Paste:=xlPasteFormulas, Operation:=xlNone, _
        SkipBlanks:=False, Transpose:=False
    Application.CutCopyMode = False
    Range("J2").Select
    'col L Total Btl Expected
    Sheets("DataEntry").Select
    Cells(2, 12) = "=(E2*J2)+K2"
    Range("L2").Select
    Selection.Copy
    Range("L3:L" & Lastrow).Select
    Selection.PasteSpecial Paste:=xlPasteFormulas, Operation:=xlNone, _
        SkipBlanks:=False, Transpose:=False
    Application.CutCopyMode = False
    Range("L2").Select
    'Col O the btl difference
    Sheets("DataEntry").Select
    Cells(2, 15) = "=I2-L2"
    Range("O2").Select
    Selection.Copy
    Range("O3:O" & Lastrow).Select
    Selection.PasteSpecial Paste:=xlPasteFormulas, Operation:=xlNone, _
        SkipBlanks:=False, Transpose:=False
    Application.CutCopyMode = False
    Range("O2").Select
    'Col P the case difference (rounded)
    Sheets("DataEntry").Select
    Cells(2, 16) = "=O2/E2"
    Range("P2").Select
    Selection.Copy
    Range("P3:P" & Lastrow).Select
    Selection.PasteSpecial Paste:=xlPasteFormulas, Operation:=xlNone, _
        SkipBlanks:=False, Transpose:=False
    Application.CutCopyMode = False
    Range("P2").Select
    'Col M "Wave Num" formula.  Using rank from col X
    Sheets("DataEntry").Select
    Cells(2, 13).Select
    Cells(2, 13) = "=IF(X2<21,""1"",IF(X2<41,""2"",IF(X2<61,""3"",IF(X2<81,""4"",IF(X2<101,""5"",IF(X2<121,""6"",IF(X2<141,""7"",IF(X2<161,""8"",IF(X2<181,""9"",""10"")))))))))"
    Range("M2").Select
    Selection.Copy
    Range("M3:M" & Lastrow).Select
    Selection.PasteSpecial Paste:=xlPasteFormulas, Operation:=xlNone, _
        SkipBlanks:=False, Transpose:=False
    Application.CutCopyMode = False
    Range("M2").Select
    'Copy paste as value wave numbers
    Sheets("DataEntry").Select
    Columns("M:M").Select
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Range("N2").Select
    Application.CutCopyMode = False
    
    
'Add The Key Column to STEP1 Sheet
    Sheets("Step1").Select
    Columns("A:A").Select
    Selection.Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    Range("A1").Select
    ActiveCell.FormulaR1C1 = "KEY"
    Range("A2").Select
    ActiveCell.FormulaR1C1 = "=CONCATENATE(RC[2],RC[1])"
    Range("A2").Select
    Selection.Copy
    Range("A3:A" & Lastrow).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Columns("A:A").Select
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    Range("B2").Select
 
'Sort by Location???
    Sheets("DataEntry").Select
    Cells.Select
    ActiveWorkbook.Worksheets("DataEntry").Sort.SortFields.Clear
    ActiveWorkbook.Worksheets("DataEntry").Sort.SortFields.Add Key:=Range( _
        "B2:B690"), SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:= _
        xlSortNormal
    With ActiveWorkbook.Worksheets("DataEntry").Sort
        .SetRange Range("A1:X690")
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
    Range("D8").Select
 'Turn On fiter
    Sheets("DataEntry").Select
    Cells.Select
    Selection.AutoFilter

End Sub

'Make the Analysis workbook  (Clears itself instead of having startup do it)

Sub MakeAnalysisSheet()

Dim Lastrow As Integer

'Refresh the Whole Analysis sheet to fresh
    Sheets("AnalysisTemplate").Select
    Cells.Select
    Range("N1").Activate
    Application.CutCopyMode = False
    Selection.Copy
    Sheets("Analysis").Select
    Cells.Select
    ActiveSheet.Paste
    Range("A2").Select

'Move over the distinct ITEMS
    Application.CutCopyMode = False
    Sheets("Step1").Columns("C:C").AdvancedFilter Action:=xlFilterCopy, _
        CriteriaRange:=Sheets("Step1").Columns("C:C"), CopyToRange:=Range("A1"), _
        Unique:=True
    
'Get the lastrow EXPECTED.
    Sheets("Analysis").Select
    With ActiveSheet
        Lastrow = .Cells(.Rows.Count, "A").End(xlUp).Row
    End With
    Sheets("DataEntry").Select

'formulas for DESC and Case Conv
    Sheets("Analysis").Select
    Cells(2, 2) = "=VLOOKUP(A2,Step1!C:D,2,FALSE)"  'description
    Range("B2").Select
    Selection.Copy
    Range("B3:B" & Lastrow).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Range("A1").Select

    Cells(2, 3) = "=VLOOKUP(A2,Step1!C:E,3,FALSE)"  'Case Conv
    Range("C2").Select
    Selection.Copy
    Range("C3:C" & Lastrow).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Range("A1").Select

'Col O (15) set wave number for filtering  (goes against DataEntry Sheet unlike the others here)
    Cells(2, 15) = "=VLOOKUP(A2,DataEntry!C:M,11,FALSE)"  'wave
    Range("O2").Select
    Selection.Copy
    Range("O3:O" & Lastrow).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Range("A1").Select
    
'Col M (13) set Cost
    Cells(2, 13) = "=VLOOKUP(A2,Step1!C:O,13,FALSE)"  'cost
    Range("M2").Select
    Selection.Copy
    Range("M3:M" & Lastrow).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Range("A1").Select
    
    
    
'Paste Special Values for cols B, C and O, M   (desc, QPC, Wave cost/case)
    Sheets("Analysis").Select
    Columns("B:C").Select
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Columns("O:O").Select
    Application.CutCopyMode = False
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    Range("P2").Select
    'cost/case
    Columns("M:M").Select
    Application.CutCopyMode = False
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    Range("P2").Select

'Formula for total cost.  STAYS A FORMULA
    Sheets("Analysis").Select
    Cells(2, 14) = "=(M2*J2)+((M2/C2)*K2)"
    Range("N2").Select
    Selection.Copy
    Range("N3:N" & Lastrow).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Range("A1").Select


'Sort Analysis by wave and then item number
    Sheets("Analysis").Select
    Cells.Select
    Range("C1").Activate
    ActiveWorkbook.Worksheets("Analysis").Sort.SortFields.Clear
    ActiveWorkbook.Worksheets("Analysis").Sort.SortFields.Add Key:=Range( _
        "O2:O196"), SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:= _
        xlSortNormal
    ActiveWorkbook.Worksheets("Analysis").Sort.SortFields.Add Key:=Range( _
        "A2:A196"), SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:= _
        xlSortNormal
    With ActiveWorkbook.Worksheets("Analysis").Sort
        .SetRange Range("A1:O196")
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
    Range("O6").Select
 'Freeze the view on analysis
    Sheets("Analysis").Select
    Range("D2").Select
    ActiveWindow.FreezePanes = True
End Sub


Sub OutPutWaveFiles()  'RUN FOURTH

'RUN AFTER MAKING THE WAVE SHEETS.  Outputs files to C:\COUNT2016  (Must exist)
Dim WaveTab As Integer
Dim Counter As Integer ' used to track how many files have been written
Counter = 0
Dim RangeStr As String ' Used to output the range like C100-C999 in the count book

For WaveTab = 1 To 10
    Sheets("Wave" & WaveTab).Select
    'Replace NA with 1  'DEFAULTS ANy ITEM THAT DIDN"T HAVE A COUNT SHEET TO SHEET ONE.
    Columns("L:L").Select
    Selection.Replace What:="#N/A", Replacement:="1", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, _
        ReplaceFormat:=False
    Cells(1, 1).Select
    
    'Sort the Sheet  By ITEM NUMBER
    Sheets("Wave" & WaveTab).Select
    Cells.Select
    ActiveWorkbook.Worksheets("Wave" & WaveTab).Sort.SortFields.Clear
    ActiveWorkbook.Worksheets("Wave" & WaveTab).Sort.SortFields.Add Key:=Range("L2:L200"), _
        SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:=xlSortNormal
    ActiveWorkbook.Worksheets("Wave" & WaveTab).Sort.SortFields.Add Key:=Range("A2:A200"), _
        SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:=xlSortNormal
    With ActiveWorkbook.Worksheets("Wave" & WaveTab).Sort
        .SetRange Range("A1:L200")
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
    Cells(1, 1).Select
    'Find start and finish ranges for each COUNTBOOK, copy them one at a time to the OUTTEMP sheet and save as a file.
    Dim BeginSectionRow As Integer
    BeginSectionRow = 2
    Dim LookRow As Integer 'itterate all rows.
    LookRow = 3
    Dim CntBook As Integer  'one at a time, what book
    CntBook = Cells(2, 12) 'First book to write out.
    
    
    Do While Len(Cells(LookRow, 12)) > 0
        If Cells(LookRow + 1, 12) <> CntBook Then
            'end a section/book.  Write it out
            Counter = Counter + 1
            MakeWaveOutFile "Tool Book Four", BeginSectionRow, LookRow, WaveTab, CntBook, Counter, GetRangeStart(CntBook) & "-" & GetRangeEnd(CntBook)
            'Make the cover sheet book too
            'MakeWaveCoverOutFile "Tool Book Two", WaveTab, CntBook
            'Debug.Print "Start: " & BeginSectionRow & "  End: " & LookRow
            Sheets("Control Log").Select
            Sheets("Control Log").Cells(Counter + 1, 2) = GetRangeStart(CntBook)  'Range Start
        
            Sheets("Control Log").Cells(Counter + 1, 3) = GetRangeEnd(CntBook)  'Range End
            Sheets("Control Log").Cells(Counter + 1, 4) = WaveTab  'Wave
            Sheets("Control Log").Cells(Counter + 1, 12) = WaveTab & "-" & CntBook  'Book ID  ww-bb
            Sheets("Wave" & WaveTab).Select
            LookRow = LookRow + 1
            BeginSectionRow = LookRow
            CntBook = Cells(LookRow, 12)
        Else
            'keep looking
            LookRow = LookRow + 1
            
        End If
    Loop
Next WaveTab



End Sub

'Private Sub MoveDataToCollectionSheet()  'Used by MakeTelleSheet
'
'    Sheets("COLLECTION").Select
'    'Clear the output sheet.
'    Range("A3:AD7000").Select
'    Application.CutCopyMode = False
'    Selection.ClearContents
'    Range("A3").Select
'
'    'Move over Item and Description
'    Sheets("RAW").Select
'    Range("N2:O1420").Select
'    Selection.Copy
'    Sheets("COLLECTION").Select
'    Cells(3, 1).Select
'    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
'        :=False, Transpose:=False
'    Range("B7").Select
'    'Get Vintage
'    Sheets("RAW").Select
'    Range("Q2:Q1420").Select
'    Selection.Copy
'    Sheets("COLLECTION").Select
'    Cells(3, 3).Select
'    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
'        :=False, Transpose:=False
'    Range("B7").Select
'    'Copy over QPC
'    Sheets("RAW").Select
'    Range("P2:P1420").Select
'    Selection.Copy
'    Sheets("COLLECTION").Select
'    Cells(3, 4).Select
'    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
'        :=False, Transpose:=False
'    'Cases Bottles TotalBottles R, S, T source to E,F,G
'    Sheets("RAW").Select
'    Range("R2:T1420").Select
'    Selection.Copy
'    Sheets("COLLECTION").Select
'    Cells(3, 5).Select
'    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
'        :=False, Transpose:=False
'    'Location
'    Sheets("RAW").Select
'    Range("M2:M1420").Select
'    Selection.Copy
'    Sheets("COLLECTION").Select
'    Cells(3, 8).Select
'    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
'        :=False, Transpose:=False
'
'End Sub



'Private Sub testMakeWaveOut()
'
'MakeWaveOutFile "Tool Book Two", 2, 12, 2, 1
'
'End Sub



Private Sub MakeWaveOutFile(ToolBookName As String, StartRow As Integer, EndRow As Integer, WaveNum As Integer, CountSheetNum As Integer, Counter As Integer, RangeStr As String)
'UTILITy PROCEDURE.  you can't run this.  :)

'Open the file
    Workbooks.Open Filename:="C:\Count2016\Template.xlsx"

'Copy in the data
    Workbooks(ToolBookName).Activate
    Sheets("Wave" & WaveNum).Select
    
    'Copy Location  IN:  A,   OUT: F
    Workbooks(ToolBookName).Activate
    Sheets("Wave" & WaveNum).Select
    Range("A" & StartRow & ":A" & EndRow).Select
    Selection.Copy
    Windows("Template.xlsx").Activate
    Sheets(2).Select
    Range("F3").Select
    ActiveSheet.Paste
    
    'Copy Item Number  IN:B  OUT A
    Workbooks(ToolBookName).Activate
    Sheets("Wave" & WaveNum).Select
    Range("B" & StartRow & ":B" & EndRow).Select
    Selection.Copy
    Windows("Template.xlsx").Activate
    Sheets(2).Select
    Range("A3").Select
    ActiveSheet.Paste
    
    'Copy Size  IN:  OUT:  C
    Workbooks(ToolBookName).Activate
    Sheets("Wave" & WaveNum).Select
    Range("M" & StartRow & ":M" & EndRow).Select
    Selection.Copy
    Windows("Template.xlsx").Activate
    Sheets(2).Select
    Range("C3").Select
    ActiveSheet.Paste
    
    ' Copy Description  IN:C    OUT: D
    Workbooks(ToolBookName).Activate
    Sheets("Wave" & WaveNum).Select
    Range("C" & StartRow & ":C" & EndRow).Select
    Selection.Copy
    Windows("Template.xlsx").Activate
    Sheets(2).Select
    Range("D3").Select
    ActiveSheet.Paste
    
    ' Copy QPC  IN:D  OUT: B
    Workbooks(ToolBookName).Activate
    Sheets("Wave" & WaveNum).Select
    Range("D" & StartRow & ":D" & EndRow).Select
    Selection.Copy
    Windows("Template.xlsx").Activate
    Sheets(2).Select
    Range("B3").Select
    ActiveSheet.Paste
    
    'Copy Vintage  IN:E    OUT: E
    Workbooks(ToolBookName).Activate
    Sheets("Wave" & WaveNum).Select
    Range("E" & StartRow & ":E" & EndRow).Select
    Selection.Copy
    Windows("Template.xlsx").Activate
    Sheets(2).Select
    Range("E3").Select
    ActiveSheet.Paste
    
    'Copy Cases and Bottles    IN:F and G         out: G and H
    Workbooks(ToolBookName).Activate
    Sheets("Wave" & WaveNum).Select
    Range("F" & StartRow & ":G" & EndRow).Select
    Selection.Copy
    Windows("Template.xlsx").Activate
    Sheets(2).Select
    Range("G3").Select
    ActiveSheet.Paste
    
    'RESET THE VIEW
    Cells(1, 1).Select
    'Rename the sheet for reference
    Sheets(2).Select
    Sheets(2).Name = "Wave-" & WaveNum & "  Range-" & CountSheetNum
 'Add the sheet name in cell A1
    Sheets(2).Select
    Cells(1, 1) = "Wave-" & WaveNum & "  Range-" & CountSheetNum
 'Add the counter book number (chronoligical) to
    Sheets(1).Select
    Cells(1, 5) = "Book " & Counter
 'Document the range this "book" contains
    Cells(10, 9) = RangeStr  'FAKE
 'Set the print range
    Sheets(2).Select
    ActiveSheet.PageSetup.PrintArea = ""
    Dim lastcell As Integer
    lastcell = 2
    Do While (Len(Cells(lastcell, 1)) > 1)
        lastcell = lastcell + 1
    Loop
    
    Range("A1:M" & lastcell).Select
    ActiveSheet.PageSetup.PrintArea = "$A$1:$M$" & lastcell
    Range("A3").Select
'Populate the cover sheet
    Sheets("coversheet").Select
    Cells(10, 3) = WaveNum
    Cells(10, 7) = CountSheetNum
    
    

'Print the file
   
    Workbooks("Template.xlsx").Activate
    Dim ws As Worksheet
    For Each ws In ActiveWorkbook.Worksheets
        With ws.PageSetup
        .LeftHeader = "&P of &N   &F"
        .CenterHeader = "Page &P of &N"
    End With
    
    Next ws
 
 'Save the file "as"
    Windows("Template.xlsx").Activate
       ActiveWorkbook.SaveAs Filename:="C:\Count2016\Wave " & WaveNum & "-Range " & CountSheetNum & ".xlsx", _
        FileFormat:=xlOpenXMLWorkbook, CreateBackup:=False
    
   ActiveWorkbook.PrintOut Copies:=1, Collate:=True, IgnorePrintAreas:=False

'Close the file
    ActiveWindow.Close


End Sub



Private Sub ClearAllWaves()  'UTILITy FUNCTION
    Dim Z As Integer  'junk counter.

'CLEAR THE WAVE SHEETS
For Z = 1 To 10
    Sheets("Wave" & Z).Select
    Range("A2:N1500").Select  '1500 is the max count book size hopefully.
    Selection.ClearContents
Next Z
Sheets("Step1").Select


End Sub





Function GetRangeStart(BookNum As Integer)

    Sheets("Reference").Select
    Columns("B:B").Select
    Selection.Find(What:=BookNum, After:=ActiveCell, LookIn:=xlFormulas, LookAt _
        :=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, MatchCase:= _
        False, SearchFormat:=False).Select
    GetRangeStart = Cells(Selection.Rows.Row, 3)

End Function
Function GetRangeEnd(BookNum As Integer)
    'Booknum is really range num
    Sheets("Reference").Select
    Columns("B:B").Select
    Selection.Find(What:=BookNum, After:=ActiveCell, LookIn:=xlFormulas, LookAt _
        :=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, MatchCase:= _
        False, SearchFormat:=False).Select
    GetRangeEnd = Cells(Selection.Rows.Row, 4)

End Function











