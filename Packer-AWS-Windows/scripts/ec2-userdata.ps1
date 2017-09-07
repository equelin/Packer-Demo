<powershell>

<#
    .SYNOPSIS 
    Powershell script is executed during the EC2 instance initialization.
    .NOTES
    - Create a new user that's going to be used for winrm and RDP communications
    - Setup WinRM communication over HTTPS with a sel-signed certificate
#>

# Define Execution Policy to unrestricted
Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force -ErrorAction Ignore

# Don't set this before Set-ExecutionPolicy as it throws an error
$ErrorActionPreference = "stop"

### Add New Packer User
# Define user variables
$Username = 'packer'
$Password = 'Password123#'
$Description = 'Packer user used for winrm configuration'

# Convert password to secure string
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force

# Create new local user
$User = New-LocalUser $Username -Password $SecurePassword -FullName $Username  -Description $Description -AccountNeverExpires -UserMayNotChangePassword

# Add new user to the local administrators group
$User  | Add-LocalGroupMember -Group (Get-LocalGroup Administrators)

### WinRM configuration
# Enable Powershell Remoting
Enable-PSRemoting -SkipNetworkProfileCheck -Force

# Enable BASIC Auth
Set-Item -Path "WSMan:\localhost\Service\Auth\Basic" "true"

# Remove HTTP listener
# Get-ChildItem WSMan:\Localhost\listener | Where-Object -Property Keys -eq "Transport=HTTP" | Remove-Item -Recurse

# Create self-signed certificate
$Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "packer"

# Add HTTPS listener using the above self-signed certificate
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint –Force

### Firewall rules
# Add firewall for remote management over HTTPS
New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5986 -Protocol TCP

# Disable firewall rule for remote management over HTTP
Disable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"

</powershell>