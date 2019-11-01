[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Subject = "",
    
    [Parameter(Mandatory=$false)]
    [string]$Password = ""
)

$cwd = Convert-Path .
$cerFile = "$cwd\$Subject.cer"
$pfxFile = "$cwd\$Subject.pfx"

# abort if files exist
if((Test-Path($pfxFile)) -or (Test-Path($cerFile)))
{
    Write-Warning "Failed, '$Subject' certificate files already exist in current directory."
    Exit
}

# include DnsName property for modern browsers
# https://groups.google.com/a/chromium.org/forum/#!topic/security-dev/IGT2fLJrAeo
$cert = New-SelfSignedCertificate `
    -Subject localhost `
    -DnsName localhost `
    -FriendlyName "Localhost Dev Certificate" `
    -NotBefore (Get-Date) `
    -NotAfter (Get-Date).AddYears(10) `
    -CertStoreLocation "cert:CurrentUser\My" `
    -KeyAlgorithm RSA `
    -KeyLength 2048 `
    -HashAlgorithm SHA256 `
    -KeyUsage DigitalSignature, KeyEncipherment, DataEncipherment `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.1") 

$certStore = 'Cert:\CurrentUser\My\' + ($cert.ThumbPrint)  
$securePass = ConvertTo-SecureString -String $Password -Force -AsPlainText

Export-PfxCertificate -Cert $certStore -FilePath $pfxFile -Password $securePass
Export-Certificate -Cert $certStore -FilePath $cerFile