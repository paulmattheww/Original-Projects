Sub Insert_Blank_Rows()

         'Select last row in worksheet.
         Selection.end(xldown).select

         Do Until ActiveCell.row = 1
            'Insert blank row.
            ActiveCell.EntireRow.Insert shift := xldown
            'Move up one row.
            ActiveCell.Offset(-1,0).Select
         Loop

      End Sub
