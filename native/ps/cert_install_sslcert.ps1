[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Subject = "",

    [Parameter(Mandatory=$true)]
    [string]$password = ""
)

# must run as admin
if( -not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Failed, must run as Administrator."
    Exit
}

$cwd = Convert-Path .
$pfxFile = "$cwd\$Subject.pfx"
$cerFile = "$cwd\$Subject.cer"

# abort if files do not exist
if(!(Test-Path($pfxFile)) -or !(Test-Path($cerFile)))
{
    Write-Warning "Failed, no $Subject.pfx or $Subject.cer in current directory."
    Exit
}

$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$cert.Import($cerFile)

$certStore = 'Cert:\CurrentUser\My\' + ($cert.ThumbPrint)  
$securePass = ConvertTo-SecureString -String $password -Force -AsPlainText

# try/catch and -erroraction because password failure is a possibility
Try
{
    Import-PfxCertificate -FilePath $pfxFile Cert:\LocalMachine\My -Password $securePass -Exportable -ErrorAction Stop
}
Catch
{
    Write-Warning "Failed, error importing $Subject.pfx. Is the password correct?"
    Exit
}

# this launches a wizard
Import-Certificate -FilePath $cerFile -CertStoreLocation Cert:\CurrentUser\Root
