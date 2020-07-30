<#
.SYNOPSIS
    Signs a client cert with a CA cert.

.DESCRIPTION
    This is can used when CSR and CA are from 2 different entities (ie. Not using self-sign certificate).
#>

param(
[Parameter(Mandatory=$false)]
[string]$caPath = "./ca",


[Parameter(Mandatory=$false)]
[string]$clientPath = "./client"
)

openssl x509 `
    -in $(Join-Path -Path "$clientPath" -ChildPath "client.csr") `
    -out $(Join-Path -Path "$clientPath" -ChildPath "client.crt") `
    -CA $(Join-Path -Path "$caPath" -ChildPath "ca.crt") `
    -CAkey $(Join-Path -Path "$caPath" -ChildPath "ca.key") `
    -pubkey -CAcreateserial -fingerprint -req

openssl pkcs12 -export `
    -name "Development $name.crt" `
    -in $(Join-Path -Path $clientPath -ChildPath "client.crt") `
    -inkey $(Join-Path -Path $clientPath -ChildPath "client.key") `
    -out $(Join-Path -Path $clientPath -ChildPath "client.pfx")

Write-Host('')
Write-Host('---- ---- ----')
Write-Host("Verify Test")
Write-Host('---- ---- ----')
openssl verify -CAfile $(Join-Path -Path $caPath -ChildPath "ca.crt") $(Join-Path -Path $clientPath -ChildPath "client.crt")