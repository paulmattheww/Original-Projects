Sub BuildWavesStep2()
    Dim s0 As Worksheet, i As Long, j As Long, LR As Long, inc As Integer, head As Range
    
    incr = 2
    
    Set s0 = Sheets("Step1")
    s0.Select
    
    Set head = Range("A1:K1")
    
    LR = Range("A" & Rows.Count).End(xlUp).Row
    For i = 2 To LR
        If Cells(i, 8).Value >= 1 And Cells(i, 8).Value <= 20 Then
            Rows(i).EntireRow.Select
            Selection.Copy
            Sheets("Wave1").Select
            Cells(incr, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Cells(1, 1).Select
            ActiveCell.EntireRow.Insert
            s0.Select
            Rows(1).EntireRow.Select
            Selection.Copy
            Sheets("Wave1").Select
            Cells(1, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Columns("A:ZZ").Sort key1:=Range("K:K"), order1:=xlAscending, key2 _
        :=Range("A:A"), order2:=xlAscending, Header:=xlYes
        incr = incr + 1
        s0.Select
        
        ElseIf Cells(i, 8).Value >= 21 And Cells(i, 8).Value <= 40 Then
            Rows(i).EntireRow.Select
            Selection.Copy
            Sheets("Wave2").Select
            Cells(incr, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Cells(1, 1).Select
            ActiveCell.EntireRow.Insert
            s0.Select
            Rows(1).EntireRow.Select
            Selection.Copy
            Sheets("Wave2").Select
            Cells(1, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Columns("A:ZZ").Sort key1:=Range("K:K"), order1:=xlAscending, key2 _
        :=Range("A:A"), order2:=xlAscending, Header:=xlYes
        incr = incr + 1
        s0.Select
        
        ElseIf Cells(i, 8).Value >= 41 And Cells(i, 8).Value <= 60 Then
            Rows(i).EntireRow.Select
            Selection.Copy
            Sheets("Wave3").Select
            Cells(incr, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Cells(1, 1).Select
            ActiveCell.EntireRow.Insert
            s0.Select
            Rows(1).EntireRow.Select
            Selection.Copy
            Sheets("Wave3").Select
            Cells(1, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Columns("A:ZZ").Sort key1:=Range("K:K"), order1:=xlAscending, key2 _
        :=Range("A:A"), order2:=xlAscending, Header:=xlYes
        incr = incr + 1
        s0.Select
        
        ElseIf Cells(i, 8).Value >= 61 And Cells(i, 8).Value <= 80 Then
            Rows(i).EntireRow.Select
            Selection.Copy
            Sheets("Wave4").Select
            Cells(incr, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Cells(1, 1).Select
            ActiveCell.EntireRow.Insert
            s0.Select
            Rows(1).EntireRow.Select
            Selection.Copy
            Sheets("Wave4").Select
            Cells(1, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Columns("A:ZZ").Sort key1:=Range("K:K"), order1:=xlAscending, key2 _
        :=Range("A:A"), order2:=xlAscending, Header:=xlYes
        incr = incr + 1
        s0.Select
        
        ElseIf Cells(i, 8).Value >= 81 And Cells(i, 8).Value <= 100 Then
            Rows(i).EntireRow.Select
            Selection.Copy
            Sheets("Wave5").Select
            Cells(incr, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Cells(1, 1).Select
            ActiveCell.EntireRow.Insert
            s0.Select
            Rows(1).EntireRow.Select
            Selection.Copy
            Sheets("Wave5").Select
            Cells(1, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Columns("A:ZZ").Sort key1:=Range("K:K"), order1:=xlAscending, key2 _
        :=Range("A:A"), order2:=xlAscending, Header:=xlYes
        incr = incr + 1
        s0.Select
        
        ElseIf Cells(i, 8).Value >= 101 And Cells(i, 8).Value <= 120 Then
            Rows(i).EntireRow.Select
            Selection.Copy
            Sheets("Wave6").Select
            Cells(incr, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Cells(1, 1).Select
            ActiveCell.EntireRow.Insert
            s0.Select
            Rows(1).EntireRow.Select
            Selection.Copy
            Sheets("Wave6").Select
            Cells(1, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Columns("A:ZZ").Sort key1:=Range("K:K"), order1:=xlAscending, key2 _
        :=Range("A:A"), order2:=xlAscending, Header:=xlYes
        incr = incr + 1
        s0.Select
        
        ElseIf Cells(i, 8).Value >= 121 And Cells(i, 8).Value <= 140 Then
            Rows(i).EntireRow.Select
            Selection.Copy
            Sheets("Wave7").Select
            Cells(incr, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Cells(1, 1).Select
            ActiveCell.EntireRow.Insert
            s0.Select
            Rows(1).EntireRow.Select
            Selection.Copy
            Sheets("Wave7").Select
            Cells(1, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Columns("A:ZZ").Sort key1:=Range("K:K"), order1:=xlAscending, key2 _
        :=Range("A:A"), order2:=xlAscending, Header:=xlYes
        incr = incr + 1
        s0.Select
        
        ElseIf Cells(i, 8).Value >= 141 And Cells(i, 8).Value <= 160 Then
            Rows(i).EntireRow.Select
            Selection.Copy
            Sheets("Wave8").Select
            Cells(incr, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Cells(1, 1).Select
            ActiveCell.EntireRow.Insert
            s0.Select
            Rows(1).EntireRow.Select
            Selection.Copy
            Sheets("Wave8").Select
            Cells(1, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Columns("A:ZZ").Sort key1:=Range("K:K"), order1:=xlAscending, key2 _
        :=Range("A:A"), order2:=xlAscending, Header:=xlYes
        incr = incr + 1
        s0.Select
        
        ElseIf Cells(i, 8).Value >= 161 And Cells(i, 8).Value <= 180 Then
            Rows(i).EntireRow.Select
            Selection.Copy
            Sheets("Wave9").Select
            Cells(incr, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Cells(1, 1).Select
            ActiveCell.EntireRow.Insert
            s0.Select
            Rows(1).EntireRow.Select
            Selection.Copy
            Sheets("Wave9").Select
            Cells(1, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Columns("A:ZZ").Sort key1:=Range("K:K"), order1:=xlAscending, key2 _
        :=Range("A:A"), order2:=xlAscending, Header:=xlYes
        incr = incr + 1
        s0.Select
        
        ElseIf Cells(i, 8).Value >= 181 And Cells(i, 8).Value <= 200 Then
            Rows(i).EntireRow.Select
            Selection.Copy
            Sheets("Wave10").Select
            Cells(incr, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Cells(1, 1).Select
            ActiveCell.EntireRow.Insert
            s0.Select
            Rows(1).EntireRow.Select
            Selection.Copy
            Sheets("Wave10").Select
            Cells(1, 1).Activate
            Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
            Columns("A:ZZ").Sort key1:=Range("K:K"), order1:=xlAscending, key2 _
        :=Range("A:A"), order2:=xlAscending, Header:=xlYes
        incr = incr + 1
        s0.Select
        
        Else
        s0.Select
        
        
        End If
    Next
    
End Sub
