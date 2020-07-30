# Setup Guide

This documents the [information](https://gist.github.com/Soarez/9688998) needed to setup your own self-signed CA certificate.

## Table of Contents

- [Setup Guide](#setup-guide)
  - [Table of Contents](#table-of-contents)
  - [Configuration](#configuration)
    - [Input](#input)
    - [Output](#output)
  - [Usage](#usage)
    - [Create self-signed certificates](#create-self-signed-certificates)
    - [Create chained certificates](#create-chained-certificates)
    - [Renew certificates](#renew-certificates)
  - [Scripts](#scripts)
    - [powershell](#powershell)
    - [cmd](#cmd)
    - [shell](#shell)
  - [TBD](#tbd)
  - [Reference](#reference)

## Configuration

When using the shell command to generate cert, you need to refer to its Usage and may require to pass in some config files as arguments.

### Input

Directory:

- ./templates (Contains configuration templates)
- ./examples (Contains configuration examples)

| File | Description |
| ------ | ------ |
| ca.config | Configuration for Certificate Authority (CA) |
| client.config | Configuration for Certificate Signing Request (CSR) |
| openssl.config | General configuration for OpenSsl |

### Output

The output folder are as follows

| File | Description |
| ------ | ------ |
| ca | Certificate Authority (CA) is meant to used for signing other certificates only. ie. `cRLSign`, `keyCertSign` |
| client | Client certificates is verified when application sends a CSR. Its purpose should be used for `serverAuth`, `clientAuth` and `codeSigning` |

Each of the folder above may contain [subfolders](https://docs.google.com/document/d/14JkmUgt9Yw5u93cbdd9ckDRp46loH6Z2Gs2Xf0JcCBk/edit#heading=h.vn1br94aial6) depending on the KeyUsages and configurations.

## Usage

The following usages are categorized for different use cases:

### Create self-signed certificates

For development purpose, certificate is self-signed

1. Execute the `make_*_cert.ps1` script to create a certificate to `./client` folder.

   ``` powershell
   ./make_*_cert.ps1 -configPath "./../examples/client.config" -outputPath "./client"
   ```

2. Ensure all keys are valid for ca certificate using `inspect_*_cert.ps1` script.

   ``` powershell
   ./inspect_*_cert.ps1 -certPath "./ca"
   ```

### Create chained certificates

For development purpose, certificate is chained from CA -> Client

1. Execute the `make_*_cert.ps1` script to create a certificate to `./ca` folder.

   ``` powershell
   ./make_*_cert.ps1 -configPath "./../examples/ca.config" -outputPath "./ca"
   ```

2. Ensure all keys are valid for ca certificate using `inspect_*_cert.ps1` script.

   ``` powershell
   ./inspect_*_cert.ps1 -certPath "./ca"
   ```

3. Execute the `make_*_cert.ps1` script again to create a certificate to `./client` folder.

   ``` powershell
   ./make_*_cert.ps1 -configPath "./../examples/client.config" -outputPath "./client"
   ```

4. Ensure all keys are valid for client certificate using `inspect_*_cert.ps1` script.

   ``` powershell
   ./inspect_*_cert.ps1 -certPath "./client"
   ```

5. By default, all certs generated above are self-signed. To sign the `client` certificate with `ca` certificate, execute `sign_*_cert`

   ``` powershell
   ./sign_*_cert.ps1 -caPath "./ca" -clientPath "./client"
   ```

### Renew certificates

Status: Require Testing

1. Execute the `renew_any_cert.ps1` script.

## Scripts

### powershell

Only rsa scripts are ready at the moment.
Directory: ./ps

| File | Description |
| ------ | ------ |
| make_*_cert.ps1 | Creates certificate components: `*.key`,`*.pubkey`, `*.csr`, `*.crt` |
| install_*_cert.ps1 | Installs certificate into specified Trust Stores |
| renew_*_cert.ps1 | Renew an old certificate for specified Trust Stores |
| remove_*_cert.ps1 | Remove certificate from specified Trust Stores |
| inspect_*_cert.ps1 | Inspect all components generated via `make_*_cert.ps1` |

``` powershell
./<file.ps1>
```

### cmd

Directory: ./cmd

``` cmd
./<file.cmd>
```

### shell

Please use [bash](https://www.thewindowsclub.com/how-to-run-sh-or-shell-script-file-in-windows-10) to execute shell files.
Directory: ./sh

``` bash
bash /path/to/<file.sh>
```

| File   | Description |
| ------ | ------ |
| cert_make_sslcert.sh | Used to generate a self-signed certificate |

## TBD

- Allow script (eg. powershell) to read and change the contents of a configuration (eg. ./examples/client.config) for the following addendums:
  - Replace the placeholder value `<hostname>`
  - Change the `hostname` input parameter to `hostnames`, and if multiple `hostnames` are passed (ie. hostname1,hostname2) into the script, then proceed to add additional hostnames as SAN.
- Do the same for cmd and sh too but focus primarily on ps.
- Google doc should explain in detail the purpose of all KeyUsage.

## Reference

1. <https://gist.github.com/Soarez/9688998>
2. <https://letsencrypt.org/docs/certificates-for-localhost/>
3. <https://www.digicert.com/kb/ssl-support/openssl-quick-reference-guide.htm>
