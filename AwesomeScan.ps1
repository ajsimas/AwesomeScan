#AwesomeScan
#Shortcut: https://goo.gl/1HJ54Q

Function Run-CCleaner{

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
}


Function Run-PatchMyPC{
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
}

Function Run-RootkitRemover{

    #Mcafee Webroot Remover

    $RootkitRemoverURL = "http://ajsimas.com/Software/rootkitremover.exe"
    $RootkitRemoverPath = "C:\Windows\Temp\rootkitremover.exe"

    Write-Output "Downloading Mcafee RootkitRemover"
    $RootkitRemover = New-Object System.Net.WebClient
    $RootkitRemover.DownloadFile($RootkitRemoverURL, $RootkitRemoverPath)

    If(!(Test-Path "C:\Windows\Logs\RootkitRemover")){
    
        Write-Output "Creating RootkitRemover log directory"
        New-Item -Path C:\Windows\Logs -Name "RootkitRemover" -ItemType "Directory"
    }

    Else{

        Write-Output "RootkitRemover log directory already exists"
    }

    Write-Output "Running Mcafee RootkitRemover"
    Start-Process -WindowStyle Hidden "C:\windows\Temp\rootkitremover.exe" -ArgumentList "/log C:\windows\Logs\rootkitremover\"
    Start-Sleep 5

    $RootkitRemoverLogDirFileCount = Get-ChildItem C:\Windows\Logs\RootkitRemover | Sort-Object LastWriteTime -Descending
    $RootkitRemoverLog = $RootkitRemoverLogDirFileCount[0].Name

    While(!(Select-String -Pattern "Scan Finished" -Path "C:\Windows\Logs\RootkitRemover\$RootkitRemoverLog")){

    }

    Get-Process rootkitremover | Stop-Process
}

Run-CCleaner
Run-PatchMyPC
Run-RootkitRemover