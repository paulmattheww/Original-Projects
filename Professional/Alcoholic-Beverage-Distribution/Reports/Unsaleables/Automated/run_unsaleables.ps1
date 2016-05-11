# run unsaleables from R; AS400 query must be run first

$R = "C:\Program Files\R\R-3.2.2\bin\Rscript.exe"
$Report = "C:\Users\pmwash\Desktop\R_files\Scripts Reports\All Missouri Reports\unsaleables_returns_dumps.R"
& $R --vanilla --slave $Report




#CMD BATCH




