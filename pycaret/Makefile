## No-code DevOpps

## https://github.com/aphrc-nocode/no-code-devops 

######################################################################

## Anything to be added is included in Sources += 

Sources += $(wildcard *.yml)
Sources += $(wildcard *.md)
Sources += $(wildcard *.cmd)
Sources += LICENSE
Sources += Dockerfile
Sources += README.md
Sources += docker-compose.yml

######################################################################

## Key variable to pass

PORT = 8000
DOCKERHUB_USERNAME = scygu
CONTAINER_NAME = no-code-pycaret
IMAGE_NAME = no-code-pycaret
IMAGE_VERSION = latest
IMAGE_LATEST = $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(IMAGE_VERSION)
IMAGE_RELEASE = $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(RELEASE_VERSION)


######################################################################

## Development version

### Build image

build:
	@echo "Do you want to force rebuild the image? (yes/no): "; \
	read FORCE_BUILD; \
	if [ "$$FORCE_BUILD" = "yes" ]; then \
		echo "Force rebuild enabled. Rebuilding the image..."; \
		docker build --no-cache -t $(IMAGE_LATEST) .; \
	elif [ -z "$$(docker images -q $(IMAGE_LATEST))" ]; then \
		echo "Image $(IMAGE_LATEST) not found. Building the image..."; \
		docker build --no-cache -t $(IMAGE_LATEST) .; \
	else \
		echo "Image $(IMAGE_LATEST) already exists. Skipping build."; \
	fi

### Stop and remove the container if exists
clean:
	@if [ "$$(docker ps -aq -f name=$(CONTAINER_NAME))" ]; then \
		echo "Container $(CONTAINER_NAME) exists. Stopping and removing it..."; \
		if [ "$$(docker ps -q -f name=$(CONTAINER_NAME))" ]; then \
			docker stop $(CONTAINER_NAME); \
		fi; \
		echo "Removing container $(CONTAINER_NAME)..."; \
		RETRY_COUNT=10; \
		while [ $$RETRY_COUNT -gt 0 ]; do \
			if docker rm -f $(CONTAINER_NAME) 2>/dev/null; then \
				echo "Container $(CONTAINER_NAME) removed successfully."; \
				break; \
			else \
				echo "Removal in progress. Retrying..."; \
				sleep 2; \
				RETRY_COUNT=$$((RETRY_COUNT - 1)); \
			fi; \
		done; \
		if [ $$RETRY_COUNT -eq 0 ]; then \
			echo "Failed to remove container $(CONTAINER_NAME) after multiple attempts."; \
			exit 1; \
		fi; \
	else \
		echo "No existing container named $(CONTAINER_NAME)."; \
	fi



### Run the container
run: build clean
	@echo "Do you want to run Dockerhub version? (yes/no)"; \
	read RUN_DOCKERHUB; \
	if [ "$$RUN_DOCKERHUB" = "yes" ]; then \
		echo "Starting the container $(CONTAINER_NAME) from Dockerhub ... "; \
		docker compose up -d; \
	else \
		echo "Starting the local container $(CONTAINER_NAME) ..."; \
		docker run -d \
		-v models:/usr/no-code-pycaret/models \
		-v logs:/usr/no-code-pycaret/logs \
		--rm --name $(CONTAINER_NAME) \
		-p $(PORT):$(PORT) $(IMAGE_LATEST); \
	fi


# Stop the container without removing it
stop:
	@if [ "$$(docker ps -q -f name=$(CONTAINER_NAME))" ]; then \
		echo "Stopping container $(CONTAINER_NAME)..."; \
		docker stop $(CONTAINER_NAME); \
	else \
		echo "Container $(CONTAINER_NAME) is not running."; \
	fi

# Remove the container only
remove-container:
	@if [ "$$(docker ps -aq -f name=$(CONTAINER_NAME))" ]; then \
		echo "Removing container $(CONTAINER_NAME)..."; \
		docker rm -f $(CONTAINER_NAME); \
	else \
		echo "No container named $(CONTAINER_NAME) exists."; \
	fi

# Cleanup dangling images and volumes (optional)
prune:
	@echo "Pruning unused Docker resources..."
	docker system prune -f

# Push the image to Docker Hub
push: build
	@echo "Pushing image $(IMAGE_LATEST) to Docker Hub..."
	docker push $(IMAGE_LATEST)

# Help target for displaying available commands
help:
	@echo "Available commands:"
	@echo "  make build   - Build the Docker image (prompts for force rebuild)"
	@echo "  make clean   - Stop and remove the container if it exists"
	@echo "  make run     - Build (with prompt), clean, and run the container"
	@echo "  make stop    - Stop the container without removing it"
	@echo "  make remove-container  - Remove the container if it exists"
	@echo "  make prune   - Remove dangling images and volumes"
	@echo "  make push    - Push the image to Docker Hub"

######################################################################
