# Developer Documentation

### Environment
A .env.example file is provided that shows the environment variables that
need to be set up.

### Build and launch
A Makefile is provided for simplifying the common tasks.

To build all the images, run `make build`, or invoke `docker compose build`
on the Compose file.

To run the application, run `make up`, or invoke `docker compose up` on the
Compose file. The volumes bind mounted should exist on $HOME/data.

### Managing containers and volumes
To manage a container, make use `docker container` commands such as
`docker start`, `docker stop`, `docker ps`, `docker exec`, `docker inspect`,
`docker logs`

To gracefully bring down the whole application, run `make down`, or invoke
`docker compose down`. By default it waits for at most 10 seconds before
killing the containers. To kill them immediately, run `make down_now` or
`docker compose down --timeout=0`

To manage volumes, make use of `docker volume` commands such as
`docker volume inspect`, `docker volume ls`, `docker volume rm`

To clean all persistent data, run `make clean`, which invokes
`docker compose down` followed by removing the volumes with
`docker volume rm <volume_name> ...`

### Project data and persistence
Persistent data are stored within a directory on the host, $HOME/data,
which are then bind mounted into the containers and treated as volumes.

Check the `docker-compose.yml` file for the declared volumes or
`docker volume ls` and `docker volume inspect` to get more information
or a volume.
