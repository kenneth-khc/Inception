*This project has been created as part of the 42 curriculum by kecheong.*

# Description
Inception is a System Administration related exercise where a WordPress website
alongside other services are set up and deployed using Docker and Docker Compose.
Its goal is to have us learn about containerization to package applications
and its dependencies into a portable unit to be deployed consistently.

# Instructions
Docker and Docker Compose are required run the containers.
A Makefile is provided to simplify the lengthy Docker Compose commands.

Simply run `make` and the application will be started up with `docker compose up`.

Run `make down` to stop the running containers, with data persisted for future runs.

Run `make clean` to stop the running containers and remove all data associated.

# Resources
These are the following resources that I have utilized in order to complete this project.

### Docker
[Docker](https://www.docker.com/) official website to learn about its ecosystem

[Docker Docs](https://docs.docker.com/) to learn about Docker concepts

The [Reference documentation](https://docs.docker.com/reference/) is used during development when writing Dockerfiles,
Compose files as well as invoking Docker commands on the CLI

### WordPress
Official [WordPress](https://wordpress.com/) website.

[WP-CLI](https://wp-cli.org/) and its [commands](https://developer.wordpress.org/cli/commands/) to programmatically interact with WordPress

### MariaDB
[MariaDB docs](https://mariadb.com/docs)

### Redis
[Redis docs](https://redis.io/docs/latest/get-started/)

### FTP
[Wikipedia](https://en.wikipedia.org/wiki/File_Transfer_Protocol) for the protocol itself

[vsftpd](https://linux.die.net/man/8/vsftpd) for the server the implements the protocol

### Adminer
Official [Adminer](https://www.adminer.org/en/) website

### phpRedisAdmin
Official [phpRedisAdmin repository](https://github.com/erikdubbelboer/phpRedisAdmin)

### HTML/CSS
[MDN docs](https://developer.mozilla.org/en-US/)

AI has been used to understand concepts and to gain more information regarding
the different services and how they work together. None of the code is AI generated.

# Project description

Each service has its Dockerfile which would create its respective Docker image.
A docker-compose.yml file is used to declare all the services for Docker Compose
to bring up and run.

All source files are under srcs/, with the mandatory requirements within a
directory with the name of the service under srcs/requirements/.
Bonus services are under srcs/requirements/bonus/

Environment variables are expected to be within a .env file within srcs/,
and all credentials are stored under secrets/

### Virtual Machines vs Docker
A virtual machine abstracts the hardware, requiring a hypervisor to manage a separate operating system.
This provides complete isolation but the setup is heavy and it is less performant.

A container is an abstraction using features provided by the OS itself. By using
namespaces and control groups, an OS can limit what a process can view and use, thereby isolating the process
from the rest of the system. It is lightweight, simpler to boot up and more efficient as it shares the same OS kernel.
Docker is a way of creating and managing such containers.

### Secrets vs Environment Variables
Both secrets and environment variables are ways for us to pass configurable information
into the container, but they differ in their intent.

Environment variables are meant for general configuration and non sensitive data
that can differ during each run of the application, such as the domain name,
port address or a flag to indicate whether we are in development or in production.
These can be easily accessed through the environment within the container.

Docker Compose secrets are files mounted directly into the running container's
filesystem. These are meant for sensitive information such as credentials and keys.
A running container would have to look inside the file mounted for the secret,
rather than have it being directly accessible through the environment.

### Docker Network vs Host Network
Docker allows containers to be isolated from the host's network stack by creating
their own network namespace. By default, a container cannot access the network
of the host, or of any other container.
A Docker Network allows us to bridge containers that have to communicate
with each other.
Containers within a bridge network are internally assigned an address in the
172.16.0.0/16 range, but they are also reachable using their respective service
names, as Docker will resolve them into a reachable IP address.

### Docker Volumes vs Bind Mounts
When a container stops running, the writable layer is erased and all data is lost.
To preserve existing state, either a named volume or a directory on the host has
to be used. By default, each container gets its own filesystem and nothing is
shared between the host and containers.

Using a named volume, Docker will manage a directory as storage for any
container or host that needs to share data. The directory is located at
/var/lib/docker/volumes but the host should not be messing with it, as the
intent is to allow the user to refer to the volume by a readable name rather
than having to worry about specific path details.

A bind mount on the other hand directly links a specific directory on the host
to a location within the container. The directory can be easily accessible from
the host, which is great for development and testing purposes. However, it exposes
the host filesystem to the container and it requires the user concern themselves
with managing the bind mount.
