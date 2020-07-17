# Setup Guide

This documents the information needed to setup your own self-signed CA certificate using native powershell commands only.

- [Openssl](./../../openssl/README.md)

## Table of Contents

- [Setup Guide](#setup-guide)
  - [Table of Contents](#table-of-contents)
  - [Usage](#usage)
    - [powershell](#powershell)
  - [Reference](#reference)

## Usage

The following use cases are covered:

- Generate a simple self-signed certificate (cert_make_sslcert.ps1)
- Generate dpapi certificate (cert_make_dpapi.ps1)
- Generate signing certificate for IdentityServer (cert_make_tokens.ps1)

### powershell

Files
| File | Description |
| ------ | ------ |
| cert_install_sslcert.ps1 | Install the certificates generated from the other scripts |
| cert_list_thumbprints.ps1 | Outputs the thumbprint for each .cer file in the current directory |
| cert_upload_azure_pfx.ps1 | Upload the certificates generated to Azure KeyVault |
| cert_make_dpapi.ps1 | Used to generate [dpapi certificates](https://en.wikipedia.org/wiki/Data_Protection_API) |
| cert_make_sslcert.ps1 | Used to generate a self-signed certificate |
| cert_make_tokens.ps1 | Used to generate cerficates for signing identity token_signing and token_validation |

## Reference

1. [Generate an Azure Application Gateway self-signed certificate with a custom root CA](https://docs.microsoft.com/en-us/azure/application-gateway/self-signed-certificates)
2. [Create a certificate for package signing](https://docs.microsoft.com/en-us/windows/msix/package/create-certificate-package-signing)
