
$directory = "C:\Users\pmwash\Desktop\Roadnet Implementation\Data\Maps\TEST\"



$files = Get-ChildItem -path $directory -recurse -include *.pdf
ForEach ($file in $files)  {
    Start-Process $file -Verb Print -PassThru -debug | %{sleep 5;$_} | kill
}


