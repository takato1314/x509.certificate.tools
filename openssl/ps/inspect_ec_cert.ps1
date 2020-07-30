<#
.SYNOPSIS
    Inspects the metadata of generated certificate and CSR using openssl.
.DESCRIPTION
    This scripts assume that all certificate components are within the same directory by default.
#>

param
(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$hostname,

[Parameter(Mandatory=$false)]
[string]$certDir = "/var/ca"
)

# Settings
$ErrorActionPreference = "Stop"

Write-Host('---- ---- ---- ---- ---- ---- ')
Write-Host("Inspect the Private Key...")
openssl ec -in localhost.key -noout -text
openssl ec -in key.pem -pubout


Write-Host('---- ---- ---- ---- ---- ---- ')
Write-Host("Inspect the CSR...")
openssl req -in localhost.csr -noout -text

Write-Host('---- ---- ---- ---- ---- ---- ')
Write-Host("Inspect the generated Certificate...")
openssl x509 -in localhost.crt -noout -text

Write-Host('---- ---- ---- ---- ---- ---- ')
Write-Host("Match Test")
Write-Host('---- ---- ----')
$privateKey = openssl pkey -in localhost.key -pubout -outform pem | sha256sum
$csrKey =  openssl req -in localhost.csr -pubkey -noout -outform pem | sha256sum
$crtKey =  openssl x509 -in localhost.crt -pubkey -noout -outform pem | sha256sum

Write-Verbose("privateKey: $privateKey")
Write-Verbose("csrKey: $csrKey")
Write-Verbose("crtKey: $crtKey")

Write-Host("Matching private key and cert: $($privateKey -eq $crtKey)")
Write-Host("Matching private key and csr: $($privateKey -eq $csrKey)")
Write-Host("Matching csr and cert: $($csrKey -eq $crtKey)")
Write-Host('---- ---- ---- ---- ---- ---- ')