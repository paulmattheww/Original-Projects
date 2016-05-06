# POWER SHELL

# Dir C:\Users\pmwash\Desktop\Roadnet Implementation\Data\Maps\TEST\*.pdf | Foreach-Object { Start-Process -Path $_.FullName -Verb Print }

#set PRINT_APP = createobject("print.application")
#set DIR = PRINT_APP.namespace("C:\Users\pmwash\Desktop\Roadnet Implementation\Data\Maps\TEST\*.pdf")
#set ITEMS = DIR.Items()

#set WIN = GetObject("winmgmts:" & {imp
#set PRINTERS = 


#cd C:

#Dir C:\Users\pmwash\Desktop\Roadnet Implementation\Data\Maps\TEST\*.pdf | Foreach-Object { Start-Process -FilePath $_.FullName – Verb Print }





#cd C:

#Dir \\Users\pmwash\Desktop\Roadnet_Implementation\Data\Maps\TEST\*.pdf | Foreach-Object { Start-Process -FilePath $_.FullName –Verb Print }


#$files = get-childitem "C:\Users\pmwash\Desktop\Roadnet_Implementation\Data\Maps\TEST" *.pdf -Recurse | Select-Object FullName 
#foreach ($file in $files) {
#    Start-Process –Verb Print 
#}

#cd C:

$directory = "C:\Users\pmwash\Desktop\Roadnet Implementation\Data\Maps\TEST\"

#Get-ChildItem -path $directory -recurse -include *.pdf | ForEach-Object {
#    Start-Process -FilePath $_.fullname -Verb Print -PassThru | %{sleep;$_} | kill
#}


$files = Get-ChildItem -path $directory -recurse -include *.pdf
ForEach ($file in $files)  {
    Start-Process $file -Verb Print -PassThru -debug | %{sleep 10;$_} | kill
}




#about_Execution_Policy
#get-executionpolicy
#set-executionpolicy remotesigned


#makecert -n "CN=PowerShell Local Certificate Root" -a sha1 `
#                -eku 1.3.6.1.5.5.7.3.3 -r -sv root.pvk root.cer `
#                -ss Root -sr localMachine

#            makecert -pe -n "CN=PowerShell User" -ss MY -a sha1 `
#                -eku 1.3.6.1.5.5.7.3.3 -iv root.pvk -ic root.cer















