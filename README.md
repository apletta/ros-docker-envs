# ros-docker-envs

### Overview
This repository contains a ROS Noetic Docker environment built on Ubuntu 20.04. Intended as an "environment wrapper"; the repository should be cloned to the same file tree location as the files/directories that will be used with the environment. The container will initialize at that file tree location, in the ROS Docker environment. GUI applications can be visualized at http://localhost:8080/vnc_auto.html.

### Initial Setup
- Note that you may need to do a little googling for host setup, but once in the container the environment management should be streamlined.
1. Install Docker.
- For Mac/Windows, [Docker Desktop](https://docs.docker.com/desktop/)
- For Linux, [Docker Engine](https://docs.docker.com/engine/install/#server)
2. Install [Docker Compose](https://docs.docker.com/compose/install/), then check with:
```
docker-compose -v
```
3. For Mac/Windows, start up the Docker daemon (e.g. run Docker Desktop application).

To interact with GUI applications, visit the following link in your web browser: http://localhost:8080/vnc_auto.html

### To use Docker:
1. Clone this repository to the same file hierarchy as the other files/directories you would like to use it with (i.e. should be in the same file tree location as the root of files you would like to work with).
- This image uses volumes so the changes you make while in the container will persist outside the container and after you close the docker image. Changes made outside the container will also appear in the container. The container will be able to access all children files/directories as the location where the repository is cloned (from inside the container); use wisely! For more information, see the [Docker volumes documentation](https://docs.docker.com/storage/volumes/).
2. Enter top level of this repository.
```
cd ros-docker-envs
```
4. Build the Docker services. This will take a little while the first time you run it, but subsequent executions should be much faster. 
```
docker-compose build
```
4. Bring services up, in detached mode.
```
docker-compose up -d
```
5. Enter the Docker container.
```
docker-compose exec rosenv zsh
```
6. Do work in container. When finished, enter `exit` to leave the container. Note that all "file" work will persist, but package installations will not (i.e. you can still install packages in the container, but they will not remain between down/up cycles. To make the packages persist, add them to the dockerfile and re-build).
- GUI applications can be visualized in a web browser page. For example, try running `rosrun rviz rviz` and then navigate to http://localhost:8080/vnc_auto.html (remember to have the ros master node running! i.e. run `roscore` in a separate terminal window; the [tmux](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) tool, already installed in the container, can be helpful for managing terminal windows)
8. When done working, bring the services down (this is technically optional but can be less resource intensive for your host machine).
```
docker-compose down
```

To bring services back up again, start at step 4. Note that for changes to the dockerfile to take effect, you will need to re-run step 3.

### Other notes:
- Add new system packages to the `rosenv.dockerfile`, or make a new custom dockerfile and reference it from the desired service in the `docker-compose.yml` file.
- You can check the status of containers using `docker-compose ps`, or with the desktop app.
- To completely remove all docker related files from your system (e.g. to clear up resources), use `docker system prune -a --volumes`. Note that this will also clear the cache, so you will need to re-build the image afterwards. See the Docker documentation for more information about [pruning to reclaim space](https://docs.docker.com/config/pruning/), and [managing file system storage for Mac](https://docs.docker.com/desktop/mac/space/).
- The `entrypoint.sh` runs on startup, and shouldn't need to be edited except for rare instances.
