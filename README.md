# ros-docker-envs

### Setup
1. Install Docker, if not already. Check with 
```
docker-compose -v
```
2. Start up Docker daemon (e.g. run Docker Desktop application).

To interact with GUI applications, visit the following link in your web browser: http://localhost:8080/vnc_auto.html


### To use Docker:
1. Enter top level of repository.
2. Build the Docker services.
```
docker-compose build
```
3. Bring services up, in detached mode.
```
docker-compose up -d
```
4. Enter the Docker container.
```
docker-compose exec rosenv zsh
```
5. Do work in container. When finished, enter `exit` to leave the container.
6. When done working, bring the services down (this is technically optional but can be less resource intensive for your host machine).
```
docker-compose down
```

To bring services back up again, start at step 3.

### Other notes:
- To completely remove all docker related files from your system (e.g. to clear up resources), use `docker system prune -a --volumes`. Note that this will also clear the cache, so you will need to re-build the image afterwards. See the Docker documentation for more information about [pruning to reclaim space](https://docs.docker.com/config/pruning/), and [managing file system storage for Mac](https://docs.docker.com/desktop/mac/space/).
- You can check the status of containers using `docker-compose ps`, or with the desktop app.
