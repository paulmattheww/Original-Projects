# format unsaleables

$Date = Get-Date
$Day = $Date.Day
$Month = $Date.Month.MonthNames
$Year = $Date.Year

$FileName = $Month + "_" + $Day + "_" + $Year + "_unsaleables_returns_dumps.xlsx"

$Excel = New-Object -comobject excel.application
$workbook = $Excel.workbooks.open("C:\Users\pmwash\Desktop\VBA Projects\utility_macros.xlsm")
$worksheet = $workbook.worksheets.item(1)
$Excel.Run("utility_macros.xlsm!FormatUnsaleablesReport")
$Workbook.close()
$Excel.quit()




















