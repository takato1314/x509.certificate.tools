<#
.SYNOPSIS
    Create a self-signed certificate for the current host using EC private key.

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
    - .key
    - .pubkey
    - .csr
    - .crt
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

# Generate a localhost certificate with ec 2048 encrypted
#openssl ecparam -list_curves
openssl ecparam -out localhost.key -genkey -name prime192v1 -param_enc explicit -check
#openssl ec -in localhost.key -des3 -out localhost.key
openssl ec -in localhost.key -out localhost.pubkey -pubout
openssl req -new -key localhost.key -out localhost.csr -config "$configPath" -verify -verbose