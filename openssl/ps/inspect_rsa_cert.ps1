﻿<#
.SYNOPSIS
    Inspect the metadata of generated certificate and CSR using openssl.

.DESCRIPTION
    Used to verify self-signed certificates only.

.PARAMETER certPath (Optional)
    Path to certificate directory generated by cert_make_*_sslcert
    Default: './client'
#>

param
(
[Parameter(Mandatory=$false)]
[string]$certPath = "./client"
)

# Settings
$ErrorActionPreference = "Stop"

# Extract file config file name to use as output file name
$name = $(Get-ChildItem -Path $certPath)[0].Basename

# Inspect
Write-Host('---- ---- ---- ---- ---- ---- ')
Write-Host("Inspect the Private Key...")
openssl rsa -in $(Join-Path -Path $certPath -ChildPath "$name.key") -noout -text
openssl rsa -in $(Join-Path -Path $certPath -ChildPath "$name.pubkey") -pubin -noout -text

Write-Host('---- ---- ---- ---- ---- ---- ')
Write-Host("Inspect the CSR...")
openssl req -in $(Join-Path -Path $certPath -ChildPath "$name.csr") -noout -text

Write-Host('---- ---- ---- ---- ---- ---- ')
Write-Host("Inspect the generated Certificate...")
openssl x509 -in $(Join-Path -Path $certPath -ChildPath "$name.crt") -noout -text

Write-Host('---- ---- ---- ---- ---- ---- ')
Write-Host('---- ---- ----')
Write-Host("Match Test")
Write-Host('---- ---- ----')
$privateKey = openssl pkey -in $(Join-Path -Path $certPath -ChildPath "$name.key") -pubout -outform pem | sha256sum
$csrKey =  openssl req -in $(Join-Path -Path $certPath -ChildPath "$name.csr") -pubkey -noout -outform pem | sha256sum
$crtKey =  openssl x509 -in $(Join-Path -Path $certPath -ChildPath "$name.crt") -pubkey -noout -outform pem | sha256sum

Write-Verbose("privateKey: $privateKey")
Write-Verbose("csrKey: $csrKey")
Write-Verbose("crtKey: $crtKey")

Write-Host("Matching private key and cert: $($privateKey -eq $crtKey)")
Write-Host("Matching private key and csr: $($privateKey -eq $csrKey)")
Write-Host("Matching csr and cert: $($csrKey -eq $crtKey)")

Write-Host('---- ---- ----')
Write-Host("Verify Test")
Write-Host('---- ---- ----')
openssl verify -show_chain -CAfile $(Join-Path -Path $certPath -ChildPath "$name.crt") $(Join-Path -Path $certPath -ChildPath "$name.crt")

Write-Host('---- ---- ---- ---- ---- ---- ')