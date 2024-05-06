# Docker Compose with NGINX and Metabase local

## Dependencies
- Docker
  - If using Apple M architecture, then may need the following:
```bash
$ export DOCKER_DEFAULT_PLATFORM=linux/arm64
```
- openssl

## Steps
1. Update /etc/hosts file to add a line with your local domain like below (local domain must include a `.` and cannot include `localhost`).
- Replace `metabase.localtest` with your own preferred local domain.
```
127.0.0.1 metabase.localtest
```


2. Edit the `config/openssl-req.conf` as needed. [See this example for more](https://www.openssl.org/docs/man1.1.1/man5/config.html).


3. Create certificates.

  - With a script:
```bash
$ ./bin/create_certs.sh
```

  - or manually:
    1. Create and enter the `certs/` folder.
```bash
$ mkdir certs
$ cd certs
```

    2. Create a private key in the `certs/` folder.
```bash
certs/ $ openssl genrsa -out metabase.localtest.key 2048
```

    3. Create a Certificate Signing Request (CSR) in the `certs/` folder.

```bash
certs/ $ openssl req -config ../config/openssl-req.conf -key metabase.localtest.key -new -out metabase.localtest.csr
```

    4. Create a self-signed certificate in the `certs/` folder.

```bash
certs/ $ openssl x509 -signkey metabase.localtest.key -in metabase.localtest.csr -req -days 365 -out metabase.localtest.crt
```

    5. Convert PEM to DER in the `certs/` folder.

```bash
certs/ $ openssl x509 -in metabase.localtest.crt -outform der -out metabase.localtest.der
```

4. Update the nginx/nginx.conf to your local domain if not using the default `metabase.localtest`.

5. Run Docker Compose
```bash
$ docker compose up -d
```

6. Visit your domain's URL in your web browser like:
- [https://metabase.localtest:443](https://metabase.localtest:443)



## TODO
- Use Let's Encrypt setup instance.
  - https://gist.github.com/ebekker/abd89a833c050669cd5a


## References
- https://www.baeldung.com/openssl-self-signed-cert
- https://www.ibm.com/docs/en/hpvs/1.2.x?topic=reference-openssl-configuration-examples
- https://www.madboa.com/geek/openssl/
- https://www.openssl.org/docs/manmaster/man1/openssl-req.html#CONFIGURATION-FILE-FORMAT
- 


