# Run Metabase on EC2 + RDS with ALB with end to end security


## Includes
- docker-compose-local/
  - for running local docker compose with Metabase, app db, maildev, and NGINX serving over HTTPS with self-signed certificate
- docker-compose-ec2/
  - for running docker compose on AWS EC2 with Amazon Linux 2 with NGINX and Metabase connecting to remote RDS and mail server

