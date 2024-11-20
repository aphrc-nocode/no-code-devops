## DevOps for the No-Code Platform

### Overview

This repo combines all the components of the back- and front- end to provide a seamless integration and workflow. It integrates [Docker](https://www.docker.com/get-started/) workflow to run the APHRC no-code APP.

### Requirements

1. Install [Docker](https://www.docker.com/get-started/)
2. Ensure the docker is running
3. Clone the repo 


### Linux OS (or WSL)

Window users can also run the APP via WSL. See [WSL](https://github.com/CYGUBICKO/wsl-setup) for installation instructions.

From the `terminal` run:

Build docker image
- Choose whether to rebuild the image or use old image. The default (Enter) will check if the image exists and do nothing, otherwise rebuild. 

	```
	make build
	```


Start a container
- Choose whether to run local image or Dockerhub image. The default (Enter) will prioritize local. 

	```
	make run
	```


Stop running container

```
make stop
```

### Push local image to Docker Hub

- Create account in [Docker Hub](https://hub.docker.com/)
- Login to Docker Hub from your local machine 

	```
	docker login
	```

- Change the `DOCKERHUB_USERNAME = scygu` variable in the [Makefile](./Makefile) or [Makefile.cmd](./Makefile.cmd) and [Docker compose file](docker-compose.yml) `` by replacing `scygu` with `your_dockerhub_username` (Docker hub user name). Then

	```
	make push
	```

### Windows OS

For Windows OS, navigate to the directory containing [Makefile.cmd](./Makefile.cmd) and open `cmd`, then for all the commands above, replace `make` with `Makefile.cmd`, e.g., to build image
	
```
Makefile.cmd build
```

### Trouble shooting

- For help on available commands
	
	```
	make help
	```
