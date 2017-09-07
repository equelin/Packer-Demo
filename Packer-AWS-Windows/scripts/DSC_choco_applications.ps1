<#
    .SYNOPSIS Installing applications using Chocolatey and DSC
#>

[CmdletBinding()]
Param ()

$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'

Write-Host "[$($MyInvocation.MyCommand.Name)] Executing script"

# Set up the DSC folder structure
Write-Host "[$($MyInvocation.MyCommand.Name)] Set up the DSC folder structure"
$dscPath = 'C:\Windows\Temp\DSC'
New-Item -Path $dscPath -ItemType Directory -Force

# Create DSC configuration
Configuration HostDSCConfiguration {
    Import-DscResource -ModuleName cChoco

    cChocoInstaller InstallChocolatey {
        InstallDir = "C:\ProgramData\chocolatey"
    }

    cChocoPackageInstaller installSysinternals {
        Name        = "sysinternals"
        DependsOn   = "[cChocoInstaller]InstallChocolatey"
        AutoUpgrade = $True
    }
}

# Start DSC configuration
Try {
    Write-Host "[$($MyInvocation.MyCommand.Name)] Start DSC configuration"
    HostDSCConfiguration -OutputPath "$dscPath"
    Start-DscConfiguration -Path "$dscPath" -Wait
}
Catch {
    $errorDetail = $Error[0]
    Write-Error -Message $errorDetail
    Exit 1
}