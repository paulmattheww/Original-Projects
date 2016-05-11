# send auto email test

$Date = Get-Date
$Day = $Date.Day
$Month = Get-Date -f "MMMM"
$Year = $Date.Year

$FileName = $Month + "_" + $Day + "_" + $Year + "_unsaleables_returns_dumps.xlsx"
$FilePath = "N:\Operations Intelligence\Monthly Reports\Unsaleables\Data\" + $FileName
$Folder = "/Operations%20Intelligence/Monthly%20Reports/Unsaleables/Data/" + $FileName
$PathTitle = "MTD Unsaleables, Returns & Dumps"

$ClickablePath = "<a href=file://localhost/N:/"+$Folder+">Month-To-Date Unsaleables by Item, Supplier & Customer</a>"

#$ClickablePath = New-Object PSObject -Property @{
#    PageUrl = PageUrl = "<a href="$FilePath">$PathTitle</a>" 
#} | ConverTo-Html



$MessageParameters = @{

    SmtpServer = "outlook.majorbrands.com"
    From = "paul.washburn@majorbrands.com"
    To = "jill.sites@majorbrands.com", "mitch.turner@majorbrands.com"
    Cc = "dan.monks@majorbrands.com", "paul.washburn@majorbrands.com"
    
    Subject = "MTD Unsaleables for " + $Month + "/" + $Day + "/" + $Year
    Body = "<html>
    <head>
        <style>
            body {background-color:lightgrey;}
            h3   {font-family: Calibri; color:blue;}
            p    {font-family: Calibri; font-size: 10pt; color:green;}
        </style>
    </head>
    <body>
        <h3>MTD Unsaleables by Item & Supplier</h3>
        <p>
                This is the first test of a custom built automatic report generator.<br />
                The mechanisms that generate this report are under development.<br /><br />
                
                Please let me know how often you would like these numbers run <br />
                and I will set it up to run at your convenience. <br /><br />
                
                Follow the path below to find MTD unsaleables by item & supplier.<br /><br />
                
                Find the summary here:  <br /> <br />" + $ClickablePath + "<br /> <br />
                
                If you plan on editing this report, then save the workbook to a<br />
                your hard drive. This will preserve the source file for others. <br />
                If you download the file, it is recommended that you filter for your<br />
                products/suppliers and delete the rest as the file is large.<br /><br />
                
                Please email <b>Paul Washburn</b> for questions/suggestions regarding the contents of the report. <br /><br /><br />
        </p>
    </body>
    </html>
    "
    
} 

Send-MailMessage @MessageParameters -BodyAsHtml



# Cc = "xxxx@majorbrands.com"
# Attachment = "C:\temp\Some random file.txt"
# SMTPPort = "587"

#home.majorbrands.com
#outlook.majorbrands.com
