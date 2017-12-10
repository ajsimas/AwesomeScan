$CCleanerURL = "http://download.piriform.com/ccsetup537.exe"
$CCleanerPath = "C:\Windows\Temp\ccsetup537.exe"
$CCleanerIniURL = "https://goo.gl/hnqhnP"
$CCleanerIniPath = "C:\Program Files\CCleaner\ccleaner.ini"

If(!(Test-Path 'C:\Program Files\CCleaner')){

    $CCleaner = New-Object System.Net.WebClient
    $CCleaner.DownloadFile($CCleanerURL, $CCleanerPath)

    Write-Output "Installing CCleaner"

    Start-Process -FilePath "C:\Windows\Temp\ccsetup537.exe" -ArgumentList /S

    Start-Sleep 30

    $CCleanerIni = New-Object System.Net.WebClient
    $CCleanerIni.DownloadFile($CCleanerIniURL, $CCleanerIniPath)
}

else{
    Write-Output "Already Installed"
}

#Update CCleaner

Start-Process -FilePath "C:\Program Files\CCleaner\CCleaner64.exe" -ArgumentList /Auto