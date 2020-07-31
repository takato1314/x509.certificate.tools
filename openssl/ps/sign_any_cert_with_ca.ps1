<#
.SYNOPSIS
    Signs a client cert with a CA cert using `openssl ca`.
    See https://gist.github.com/Soarez/9688998#openssl-ca.

.DESCRIPTION
    This is can used when CSR and CA are from 2 different entities (ie. Not using self-sign certificate).
    The following folder/files are required to be available:
      - newcerts
      - serial (hex serial number)
      - index.txt (database)
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
# https://gist.github.com/Soarez/9688998#openssl-ca
openssl ca `
    -config $configPath `
    -extfile $configPath -extensions 'v3_ca' -days 365 `
    -out $(Join-Path -Path $clientPath -ChildPath "$clientName.crt") `
    -infiles $(Join-Path -Path $clientPath -ChildPath "$clientName.csr") `

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