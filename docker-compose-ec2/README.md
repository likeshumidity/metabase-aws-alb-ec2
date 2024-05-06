# Docker Compose with NGINX and Metabase on AWS EC2 with end to end encryption

## Dependencies
- Docker
- openssl
- git

## Steps
1. Run an AWS EC2 t2.small or larger (recommend t2.medium or larger) in a private subnet.
  - Add NAT Gateway, Route Table routes, and Internet Gateway to allow egress for yum and docker

2. SSH into EC2 terminal and run the following:

```bash
$ sudo yum update -y
$ sudo yum install docker -y
$ sudo service docker start
$ sudo usermod -a -G docker ec2-user  # Optional, allows managing docker without sudo
```

3. Logout and log back into to create new EC2 terminal session

4. Install Docker Compose plugin locally. [See Docker docs for more](https://docs.docker.com/compose/install/linux/#install-the-plugin-manually)

```bash
$ DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
$ mkdir -p $DOCKER_CONFIG/cli-plugins
$ curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
$ chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
```

5. Test successful Docker and Docker Compose installations.

```bash
$ docker version
$ docker compose version
```

6. Copy this repo's files in docker-compose-ec2/ to ~/docker-compose-ec2/ on the EC2 either with git clone or scp.

```bash
# On local machine with SSH access to EC2
$ scp -r ./docker-compose-ec2 ec2-user@remote-url-for-ec2:~/docker-compose-ec2
```

7. Edit the `config/openssl-req.conf` as needed. [See this example for more](https://www.openssl.org/docs/man1.1.1/man5/config.html).
  - Replace `EC2_LOCAL_DOMAIN` with the EC2 hostname
```bash
# In EC2 terminal run the following command to get the hostname
$ uname -n
````

8. Create certificates.

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

9. Update the nginx/nginx.conf to your local domain if not using the default `metabase.localtest`.

10. Update `docker-compose.yml` and replace PUBLIC_DOMAIN with your public domain name.

11. Update `.env` by copying `sample.env` and update credentials to point to your RDS application database and email host

12. Create AWS EC2 Target Group in the same VPC as EC2 instance with Protocal HTTPS and Port 443 with HTTPS Healthcheck at /api/health

13. Register EC2 instance as target with port 443

14. Create public certificate for ALB using AWS ACM and the public domain name to be used (same used in Step 10).

15. Create ALB in same VPC as EC2 instance on public subnets with a security group that has 443 permissions to access the EC2 instance with a 443 HTTPS listener.gg

16. Run Docker Compose on AWS EC2 instance to start NGINX and Metabase
```bash
$ docker compose up -d
```

13. Visit your domain's URL in your web browser like:
- [https://PUBLIC_DOMAIN:443](https://PUBLIC_DOMAIN:443)



## TODO
- Use Let's Encrypt setup instance.
  - https://gist.github.com/ebekker/abd89a833c050669cd5a


## References
- https://www.baeldung.com/openssl-self-signed-cert
- https://www.ibm.com/docs/en/hpvs/1.2.x?topic=reference-openssl-configuration-examples
- https://www.madboa.com/geek/openssl/
- https://www.openssl.org/docs/manmaster/man1/openssl-req.html#CONFIGURATION-FILE-FORMAT
- 


