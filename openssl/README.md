# Setup Guide

This documents the [information](https://gist.github.com/Soarez/9688998) needed to setup your own self-signed CA certificate.

## Table of Contents

- [Setup Guide](#setup-guide)
  - [Table of Contents](#table-of-contents)
  - [Configuration](#configuration)
  - [Usage](#usage)
    - [powershell](#powershell)
    - [cmd](#cmd)
    - [shell](#shell)
  - [TBD](#tbd)
  - [Reference](#reference)

## Configuration

When using the shell command to generate cert, you need to refer to its Usage and may require to pass in some config files as arguments.

Directory:

- ./templates (Contains configuration templates)
- ./examples (Contains configuration examples)

| File | Description |
| ------ | ------ |
| ca.config | Configuration for Certificate Authority (CA) |
| csr.config | Configuration for Certificate Signing Request (CSR) |
| openssl.config | Configuration for OpenSsl |

## Usage

The following use cases are covered:

- Generate a simple self-signed certificate

### powershell

All powershell scripts here are tend to follow the same use case as [shell](#shell) and therefore will most likely just invoke the shell scripts via reference. Only exclusive use cases are documented here.

Directory: ./ps

### cmd

All cmd scripts here are tend to follow the same use case as [shell](#shell) and therefore will most likely just invoke the shell scripts via reference. Only exclusive use cases are documented here.

Directory: ./cmd

### shell

Please use [bash](https://www.thewindowsclub.com/how-to-run-sh-or-shell-script-file-in-windows-10) to execute shell files.
Directory: ./sh

``` bash
bash /path/to/<file.sh>
```

| File | Description |
| ------ | ------ |
| cert_make_sslcert.sh | Used to generate a self-signed certificate |

## TBD

- Allow reference from cmd to bash shell.

## Reference

1. https://gist.github.com/Soarez/9688998
2. https://letsencrypt.org/docs/certificates-for-localhost/ 