<#
.SYNOPSIS
    Create a self-signed certificate for the current host using DSA private key.

.DESCRIPTION
    The openssl configuration directory used by default is contained within this project.
    To use systems directory, please provide the parameter `$configPath` 

.PARAMETER hostnames
    Hostnames generated for this certificate.
.PARAMETER configPath (Optional)
    Path to openssl config file
    Default: './../examples/csr.config'
.PARAMETER outputPath (Optional)
    Path to output files
    Default: './client'

.OUTPUT
    - localhost.key
    - localhost.pubkey
    - localhost.csr
    - localhost.crt
#>

param
(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string[]]$hostnames,

[Parameter(Mandatory=$true)]
[string]$configPath
)

# Settings
$ErrorActionPreference = "Stop"

# Variables
$hostname, $otherHostnames = $hostnames;

# Extract file config file name to use as output file name
$name = $(Get-Item $configPath).Basename

# Generate a localhost certificate with dsa 2048 encrypted
openssl dsaparam -out localhost.key -genkey 2048
openssl dsa -in localhost.key -pubout -out localhost.pubkey
#openssl dsa -in localhost.key -des3 -out localhost.key
openssl req -new -key localhost.key -out localhost.csr -config "$configPath" -verify -verbose