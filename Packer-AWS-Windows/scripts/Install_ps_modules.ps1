<#
    .SYNOPSIS Installing modules from the Powershell gallery
    .NOTES Those module are required by DSC
#>

[CmdletBinding()]
Param ()

$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'

Write-Host "[$($MyInvocation.MyCommand.Name)] Executing script"

Try {
    Install-module -Name xWindowsUpdate,cChoco -Confirm:$False
} 
Catch {
    Write-Error -Message "Error when installing module"
    Exit 1
} 
