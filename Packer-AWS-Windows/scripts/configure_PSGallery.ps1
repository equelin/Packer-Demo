<#
    .SYNOPSIS Configuring Powershell Gallery as a trusted NuGet repository 
#>

[CmdletBinding()]
Param ()

Write-Host "[$($MyInvocation.MyCommand.Name)] Executing script"


Try {
    Write-Host "[$($MyInvocation.MyCommand.Name)] Installing Package Provider NuGet"
    Install-PackageProvider -Name NuGet -Force -Confirm:$False
}
Catch {
    Write-Error $_    
    Exit 1
}

Try {
    Write-Host "[$($MyInvocation.MyCommand.Name)] Setting PSRepository"
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted    
}
Catch {
    Write-Error $_
    Exit 1
}

