# send auto email test

$MessageParameters = @{
    
    From = "paul.washburn@x.com"
    To = "dan.monks@x.com"
    Cc = "paul.washburn@x.com"
    
    Subject = "Testing Auto Email"
    Body = "This is a test to see if the auto-email worked"
    
    SmtpServer = "outlook.x.com"
} 

Send-MailMessage @MessageParameters -BodyAsHtml



# Cc = "xxxx@x.com"
# Attachment = "C:\temp\Some random file.txt"
# SMTPPort = "587"

#home.x.com
#outlook.x.com
