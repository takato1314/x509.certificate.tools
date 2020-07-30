# Status: Require Testing
<#
.SYNOPSIS
    Renew an existing certificate
#>

param
(
[Parameter(Mandatory=$false)]
[string]$caPath = "./ca",

[Parameter(Mandatory=$false)]
[string]$clientPath = "./client"
)

# Settings
$ErrorActionPreference = "Stop"

# Extract file config file name to use as output file name
$caName = $(Get-ChildItem -Path $caPath)[0].Basename
$clientName = $(Get-ChildItem -Path $clientPath)[0].Basename

# Create brand new CSR
openssl x509 -x509toreq `
    -in $(Join-Path -Path "$clientPath" -ChildPath "$clientName.crt") `
    -out $(Join-Path -Path "$clientPath" -ChildPath "$clientName.csr") `
    -signkey $(Join-Path -Path "$caPath" -ChildPath "$caName.key")

# Create brand new cert
openssl x509 `
    -in $(Join-Path -Path "$clientPath" -ChildPath "$clientName.csr")`
    -out $(Join-Path -Path "$clientPath" -ChildPath "$clientName.crt") `
    -signkey $(Join-Path -Path "$caPath" -ChildPath "$caName.key")