<#
.SYNOPSIS
    Creates a self-signed certificate for your local kubernetes nginx ingress usage.
    Default password: 'admin'

.DESCRIPTION
    See the following for more info:
    - https://kubernetes.io/docs/concepts/services-networking/ingress/#tls 
    - https://kubernetes.github.io/ingress-nginx/user-guide/tls/
    - http://woshub.com/how-to-create-self-signed-certificate-with-powershell/ 

.PARAMETER Subject (Mandatory)
    Your ingress hostname
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Subject = ""
)

# Settings
$ErrorActionPreference = "Stop"

# Variables
$localCertStore = 'cert:\LocalMachine\My\'
$cerFile = Join-Path -Path $pwd -ChildPath "localhost.cer"
$pfxFile = Join-Path -Path $pwd -ChildPath "localhost.pfx"

# abort if files exist
if((Test-Path($pfxFile)) -or (Test-Path($cerFile)))
{
    Write-Host "Overriding files `localhost.cer` and `localhost.pfx` in current directory."
}

# include DnsName property for modern browsers
# https://groups.google.com/a/chromium.org/forum/#!topic/security-dev/IGT2fLJrAeo
$cert = New-SelfSignedCertificate `
    -Subject $Subject `
    -DnsName $Subject `
    -FriendlyName "$Subject Dev Certificate" `
    -NotBefore (Get-Date) `
    -NotAfter (Get-Date).AddYears(1) `
    -CertStoreLocation "$localCertStore" `
    -KeyAlgorithm RSA `
    -KeyLength 2048 `
    -HashAlgorithm SHA256 `
    -KeyUsage DigitalSignature, KeyEncipherment, DataEncipherment `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.1") 

Write-Host("Certificate created:")
Write-Host($cert)
Write-Host("---- ---- ---- ---- ---- ----")
Write-Host("")

Write-Host("Exporting certificates...")
$certLocation = $localCertStore + $cert.ThumbPrint
Write-Host($certLocation)
$securePass = ConvertTo-SecureString -String "admin" -Force -AsPlainText
Export-PfxCertificate -Cert $certLocation -FilePath $pfxFile -Password $securePass
Export-Certificate -Cert $certLocation -FilePath $cerFile
Write-Host("---- ---- ---- ---- ---- ----")
Write-Host("")

$result = Test-Certificate -Cert $certLocation -AllowUntrustedRoot -Policy SSL -DNSName "dns=$Subject"
Write-Host("Verify certificates: $result")
