
# Certificate Tools

This repository contains solutions that can be used to generate self-signed localhost certificates using various tools.

| Solution    | Description     |
| ----------- | --------------- |
| [Minica](./minica) | [Minica](https://github.com/jsha/minica) is a simple CA intended for use in situations where the CA operator also operates each host where a certificate will be used. It automatically generates both a key and a certificate when asked to produce a certificate. |
| [Openssl](./openssl) | [OpenSSL](https://www.openssl.org/) is a robust, commercial-grade, and full-featured toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols.    |
| [Powershell](./native/ps) | [Powershell](https://docs.microsoft.com/en-us/powershell/) uses [`New-SelfSignedCertificate`](https://docs.microsoft.com/en-us/powershell/module/pkiclient/new-selfsignedcertificate?view=win10-ps) to generate self-signed certificates for localhost |

## Table of Contents

- [Certificate Tools](#certificate-tools)
  - [Table of Contents](#table-of-contents)
  - [Identity Server 4](#identity-server-4)
  - [References](#references)

## Identity Server 4

Repository for code modified in my blog articles:

- [Localhost SSL and IdentityServer4 Token Certificates](https://mcguirev10.com/2018/01/04/localhost-ssl-identityserver-certificates.html)
- [Storing X509 Certificates in Azure Key Vault](https://mcguirev10.com/2018/01/10/storing-certificates-azure-keyvault.html)

## References

1. https://www.openssl.org/docs/man1.1.0/man1/req.html
2. https://pki-tutorial.readthedocs.io/en/latest/
3. https://gist.github.com/Soarez/9688998
