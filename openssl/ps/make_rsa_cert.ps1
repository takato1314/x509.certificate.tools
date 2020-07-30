<#
.SYNOPSIS
    Create a self-signed certificate for the current host using RSA private key..

.DESCRIPTION
    The openssl configuration directory used by default is contained within this project.
    To use systems directory, please provide the parameter `$configPath` 

.PARAMETER configPath (Optional)
    Path to openssl config file
    Default: './../examples/csr.config'
.PARAMETER outputPath (Optional)
    Path to output files
    Default: './client'

.OUTPUT
    - .key
    - .pubkey
    - .csr
    - .crt
#>

param
(
[Parameter(Mandatory=$false)]
[string]$configPath = './../examples/client.config',

[Parameter(Mandatory=$false)]
[string]$outputPath = './client'
)

# Settings
$ErrorActionPreference = "Stop"

# Variables
#$hostname, $otherHostnames = $hostnames;

if (-not (Test-Path -Path $outputPath)){
  New-Item $outputPath -itemtype directory
}

# Extract file config file name to use as output file name
$name = $(Get-Item $configPath).Basename

# Generate a $name certificate with rsa 2048 encrypted
Write-Host $name
openssl genrsa -out $(Join-Path -Path $outputPath -ChildPath "$name.key") 2048
#openssl rsa -in $(Join-Path -Path $outputPath -ChildPath "$name.key") -des3 -out $(Join-Path -Path $outputPath -ChildPath "$name.key")
openssl rsa -in $(Join-Path -Path $outputPath -ChildPath "$name.key") -pubout -out $(Join-Path -Path $outputPath -ChildPath "$name.pubkey") -check
openssl req -new -key $(Join-Path -Path $outputPath -ChildPath "$name.key") -out $(Join-Path -Path $outputPath -ChildPath "$name.csr") -config "$configPath" -verify -verbose
openssl req -new -key $(Join-Path -Path $outputPath -ChildPath "$name.key") -out $(Join-Path -Path $outputPath -ChildPath "$name.crt") -config "$configPath" -x509 -days 365 -verify -verbose
openssl pkcs12 -export -name "Development $name.crt" -in $(Join-Path -Path $outputPath -ChildPath "$name.crt") -inkey $(Join-Path -Path $outputPath -ChildPath "$name.key") -out $(Join-Path -Path $outputPath -ChildPath "$name.pfx")

# Alternative
#openssl req -x509 -out $(Join-Path -Path $outputPath -ChildPath "$name.crt") -keyout $(Join-Path -Path $outputPath -ChildPath "$name.key") -config "$configPath" -verify -verbose
#openssl req -new -key $(Join-Path -Path $outputPath -ChildPath "$name.key") -out $(Join-Path -Path $outputPath -ChildPath "$name.csr") -config "$configPath" -verify -verbose
#openssl rsa -in $(Join-Path -Path $outputPath -ChildPath "$name.key") -pubout -out $(Join-Path -Path $outputPath -ChildPath "$name.pubkey") -check
