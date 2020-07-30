# https://stackoverflow.com/questions/27745161/openssl-self-signed-root-ca-certificate-set-a-start-date

openssl req -x509 -out localhost.crt -keyout localhost.key -newkey rsa:2048 -nodes -sha256 -subj "/CN=localhost" -extensions EXT -config "../examples/csr/localhost.config"