## No-code DevOpps

## https://github.com/aphrc-nocode/no-code-devops 

current: target
-include target.mk

vim_session:
	bash -cl "vmt"

autopipeR = defined

######################################################################

## Anything to be added is included in Sources += 

Sources += $(wildcard *.yml)
Sources += $(wildcard *.md)
Sources += LICENSE
Sources += Dockerfile
Sources += README.md
Sources += docker-compose.yml

######################################################################

## Key variable to pass

docker-username = scygu
app-port = 3838
local-container = no-code-app-local

######################################################################

## Development version

### Build image
build-image:
	docker build -t ${docker-username}/no-code-app .

### Start local image

# Check if the container exists and remove it
.PHONY: run-local-image
run-local-image:
	@if [ $$(docker ps -a -q -f name=$(local-container)) ]; then \
		echo "Container $(local-container) exists. Starting..."; \
		docker start $(local-container); \
	else \
		echo "Container $(local-container) does not exist. Starting container"; \
		docker run --name ${local-container} -p ${app-port}:${app-port} ${docker-username}/no-code-app; \
	fi

### Stop local image
stop-local-image:
	docker stop ${local-container}

### Push image to dockerhub
push-image:
	docker push ${docker-username}/no-code-app

## Compiled image in dockerhub

### Run containers from dockerhub
run-dockerhub-image:
	docker compose up -d

### Stop containers from docker hub
stop-dockerhub-image:
	docker compose down no-code-app

######################################################################

### Makestuff

Sources += Makefile

## Sources += content.mk
## include content.mk

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls makestuff/Makefile

makestuff/%.stamp:
	- $(RM) makestuff/*.stamp
	(cd makestuff && $(MAKE) pull) || git clone $(msrepo)/makestuff
	touch $@

-include makestuff/os.mk

-include makestuff/chains.mk
-include makestuff/texi.mk
-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
