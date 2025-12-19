# User Documentation

### Understanding the services
The main services provided by the stack are a secure, deployable WordPress
website with persistent storage on top of several other small services to
improve the administration and user experience.

An [Nginx](https://nginx.org/) service sits as the entry point to the
application, and it routes the request based on the domain name requested
into the intended service. Nginx details its behaviour and directives within the
configuration file in their [documentation](https://nginx.org/en/docs/)

A [PHP FastCGI Process Manager](https://www.php.net/manual/en/install.fpm.php)
handles the requests for [WordPress](https://wordpress.org/documentation/),
and then invokes the correct Wordpress .php file. Any data submitted would
be persisted within a [MariaDB](https://mariadb.com/) instance.
[Adminer](https://www.adminer.org/en/) acts as a web interface for MariaDB,
allowing users and administrators to interact with the database graphically.

[Redis](https://redis.io/) is enabled to speed up look ups for data by storing
them in memory, reducing the need to access the database frequently.
[phpRedisAdmin](https://github.com/erikdubbelboer/phpRedisAdmin) acts as a
web interface to interact with Redis graphically, similar to that of Adminer.

### Starting and stopping the project
A Makefile is provided for simplifying the common tasks.

To build all the images, run `make build`

To run the application, run `make up`

To bring down the application, run `make down`

To clean all persistent data, run `make clean`

### Access the website and administration panel
For simplicity, edit your /etc/hosts file to have the domain names resolve to
localhost.

[https://kecheong.42.fr](https://kecheong.42.fr) to access the main WordPress
website.

[https://adminer.kecheong.42.fr](https://adminer.kecheong.42.fr) to access the
MariaDB web interface.

[https://redis-admin.kecheong.42.fr](https://redis-admin.kecheong.42.fr) will
access the Redis web interface.

[https://showcase-kecheong.42.fr](https://showcase-kecheong.42.fr) will access
a simple showcase site.

### Locate and manage credentials
Credentials will be stored under secrets/ and parsed by the containers on
runtime. Example files are provided to show the expected credentials.

### Check that the services are running correctly
To check running containers, use `docker ps`

To check the logs of a container, use `docker logs <container name>`
