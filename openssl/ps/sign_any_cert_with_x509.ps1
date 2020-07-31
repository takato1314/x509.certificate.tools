<#
.SYNOPSIS
    Signs a client cert with a CA cert using `openssl x509`.
    See https://gist.github.com/Soarez/9688998#signing.

.DESCRIPTION
    This is can used when CSR and CA are from 2 different entities (ie. Not using self-sign certificate).
#>

param(
[Parameter(Mandatory=$false)]
[string]$configPath = './../examples/client.config',

[Parameter(Mandatory=$false)]
[string]$caPath = "./ca",


[Parameter(Mandatory=$false)]
[string]$clientPath = "./client"
)

# Settings
$ErrorActionPreference = "Stop"

# Extract file config file name to use as output file name
$caName = $(Get-ChildItem -Path $caPath -File)[0].Basename
$clientName = $(Get-ChildItem -Path $clientPath -File)[0].Basename

# Sign client cert with ca cert
# https://gist.github.com/Soarez/9688998#signing
openssl x509 `
    -extfile "$configPath" -extensions "v3_ca" `
    -req -pubkey -CAcreateserial -fingerprint -days 365 `
    -in $(Join-Path -Path "$clientPath" -ChildPath "$clientName.csr") `
    -out $(Join-Path -Path "$clientPath" -ChildPath "$clientName.crt") `
    -CA $(Join-Path -Path "$caPath" -ChildPath "$caName.crt") `
    -CAkey $(Join-Path -Path "$caPath" -ChildPath "$caName.key")

# Convert .crt to .pfx
openssl pkcs12 -export `
    -name "Development $clientName.crt" `
    -in $(Join-Path -Path $clientPath -ChildPath "$clientName.crt") `
    -inkey $(Join-Path -Path $clientPath -ChildPath "$clientName.key") `
    -out $(Join-Path -Path $clientPath -ChildPath "$clientName.pfx")

Write-Host('')
Write-Host('---- ---- ----')
Write-Host("Verify Test")
Write-Host('---- ---- ----')
openssl verify -show_chain `
    -CAfile $(Join-Path -Path $caPath -ChildPath "$caName.crt") `
    $(Join-Path -Path $clientPath -ChildPath "$clientName.crt")