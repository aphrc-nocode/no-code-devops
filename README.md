## DevOps for the No-Code Platform

### Overview

This repo combines all the components of the back- and front- end to provide a seamless integration and workflow. It integrates [Docker](https://www.docker.com/get-started/) workflow to run the APHRC no-code APP.

### Requirements

1. Install [Docker](https://www.docker.com/get-started/) 


### Local setup

#### Linux OS (or WSL)

Window users can also run the APP via WSL. See [WSL](https://github.com/CYGUBICKO/wsl-setup) for instructions.

From the `terminal` run:

Build docker image

```
make build-image
```


Start the APP using the local docker image

```
make run-local-image
```

Stop the running local image

```
make stop-local-image
```

### Push local image to Docker Hub

- Create account in [Docker Hub](https://hub.docker.com/)
- Login to Docker Hub from your local machine 

	```
	docker login
	```

- Change the `docker-username = scygu` variable in the `Makefile` by replacing `scygu` with `your_dockerhub_username` (Docker hub user name). Then

	```
	make push-image
	```

### Run Docker hub 

This set up uses the image from docker hub and the `docker-compose.yml` file.

To run latest version of the image from docker hub:

```
make run-dockerhub-image
```

Stop the running container

```
make stop-dockerhub-image
```

