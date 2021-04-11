# Wordpress Development Environment

A simple development environment for Wordpress plugins and themes.

## Prerequisites
- [Docker](https://www.docker.com/)

## Included in the environment

The following services will be setup using Docker:

- MySQL (localhost:3306)
- Wordpress (localhost:8080)
- PhpMyAdmin (localhost:8081)

You can use the following credentials to log into basically everything:

- Username: wordpress
- Password: wordpress
- Database: wordpress

## Running the environment
Run the following:
```
docker-compose up -d
```
