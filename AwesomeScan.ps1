#CCleaner

$CCleanerInstallerURL = "http://download.piriform.com/ccsetup537.exe"
$CCleanerInstallerPath = "C:\Windows\Temp\ccsetup537.exe"
$CCleanerIniURL = "https://goo.gl/S9WXgz"
$CCleanerIniPath = "C:\Program Files\CCleaner\ccleaner.ini"

If(!(Test-Path 'C:\Program Files\CCleaner')){

    $CCleanerInstaller = New-Object System.Net.WebClient
    $CCleanerInstaller.DownloadFile($CCleanerInstallerURL, $CCleanerInstallerPath)

    Write-Output "Installing CCleaner"

    Start-Process -FilePath "C:\Windows\Temp\ccsetup537.exe" -ArgumentList /S

    While(!(Test-Path 'C:\Program Files\CCleaner')){
        Start-Sleep 5    
    }
}

else{
    Write-Output "CCleaner already installed"
}

Write-Output 'Attempting to update CCleaner'
Start-Process -FilePath 'C:\Program Files\CCleaner\CCUpdate.exe'
Start-Sleep 2

If(!(Test-Path 'C:\Program Files\CCleaner\ccleaner.ini')){
    
    Write-Output 'Downloading CCleaner Configuration'
    $CCleanerIni = New-Object System.Net.WebClient
    $CCleanerIni.DownloadFile($CCleanerIniURL, $CCleanerIniPath)
    Start-Sleep 2
}

else{
    Write-Output 'Configuration already downloaded.'
}

Write-Output 'Running CCleaner'
Start-Process -FilePath "C:\Program Files\CCleaner\CCleaner64.exe" -ArgumentList /Auto


#PatchMyPC

$PatchMyPCInstallerURL = "http://ajsimas.com/Software/PatchMyPC.exe"
$PatchMyPCInstallerPath = "C:\Windows\Temp\PatchMyPC.exe"

If((Get-Process "PatchMyPC" -ErrorAction SilentlyContinue) -ne $Null){
    
    Write-Output "Killing PatchMyPC"
    $PatchMyPCProcess = Get-Process "PatchMyPC"
    $PatchMyPCProcessPID = $PatchMyPCProcess.Id
    Start-Process -FilePath "taskkill" -ArgumentList "/PID $PatchMyPCProcessPID /f"
    Start-Sleep 5
}

If(!(Test-Path "C:\windows\temp\PatchMyPC.exe")){
    
    Write-Output "Downloading PatchMyPC"
    $PatchMyPCInstaller = New-Object System.Net.WebClient
    $PatchMyPCInstaller.DownloadFile($PatchMyPCInstallerURL, $PatchMyPCInstallerPath)
}

Write-Output "Running PatchMyPC"
Start-Process -FilePath "C:\Windows\Temp\PatchMyPC.exe" -ArgumentList /s

