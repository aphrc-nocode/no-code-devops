@echo off
rem Key variables to pass
set PORT=3838
set DOCKERHUB_USERNAME=scygu
set CONTAINER_NAME=no-code-app
set IMAGE_NAME=no-code-app
set IMAGE_VERSION=latest
set IMAGE_LATEST=%DOCKERHUB_USERNAME%/%IMAGE_NAME%:%IMAGE_VERSION%

rem Check for the target passed as an argument
if "%1"=="" goto help

if /i "%1"=="build" goto build
if /i "%1"=="clean" goto clean
if /i "%1"=="run" goto run
if /i "%1"=="stop" goto stop
if /i "%1"=="remove-container" goto remove_container
if /i "%1"=="prune" goto prune
if /i "%1"=="push" goto push
if /i "%1"=="help" goto help

echo Invalid target. Run the script with `help` to see available commands.
exit /b

:build
set /p FORCE_BUILD="Do you want to force rebuild the image? (yes/no): "
if /i "%FORCE_BUILD%"=="yes" (
    echo Force rebuild enabled. Rebuilding the image...
    docker build -t %IMAGE_LATEST% .
) else (
    for /f "delims=" %%i in ('docker images -q %IMAGE_LATEST%') do set IMAGE_ID=%%i
    if not defined IMAGE_ID (
        echo Image %IMAGE_LATEST% not found. Building the image...
        docker build -t %IMAGE_LATEST% .
    ) else (
        echo Image %IMAGE_LATEST% already exists. Skipping build.
    )
)
exit /b

:clean
for /f "delims=" %%i in ('docker ps -aq --filter "name=%CONTAINER_NAME%"') do set CONTAINER_ID=%%i
if defined CONTAINER_ID (
    echo Container %CONTAINER_NAME% exists. Stopping and removing it...
    docker stop %CONTAINER_NAME% >nul 2>&1
    docker rm -f %CONTAINER_NAME%
) else (
    echo No existing container named %CONTAINER_NAME%.
)
exit /b

:run
call :build
call :clean
set /p RUN_DOCKERHUB="Do you want to run Dockerhub version? (yes/no): "
if /i "%RUN_DOCKERHUB%"=="yes" (
    echo Starting the container %CONTAINER_NAME% from Dockerhub...
    docker compose up -d
) else (
    echo Starting the local container %CONTAINER_NAME%...
    docker run -d ^
        -v datasets:/usr/no-code-app/datasets ^
        -v log_files:/usr/no-code-app/.log_files ^
        --rm --name %CONTAINER_NAME% ^
        -p %PORT%:%PORT% %IMAGE_LATEST%
)
exit /b

:stop
for /f "delims=" %%i in ('docker ps -q --filter "name=%CONTAINER_NAME%"') do set CONTAINER_ID=%%i
if defined CONTAINER_ID (
    echo Stopping container %CONTAINER_NAME%...
    docker stop %CONTAINER_NAME%
) else (
    echo Container %CONTAINER_NAME% is not running.
)
exit /b

:remove_container
for /f "delims=" %%i in ('docker ps -aq --filter "name=%CONTAINER_NAME%"') do set CONTAINER_ID=%%i
if defined CONTAINER_ID (
    echo Removing container %CONTAINER_NAME%...
    docker rm -f %CONTAINER_NAME%
) else (
    echo No container named %CONTAINER_NAME% exists.
)
exit /b

:prune
echo Pruning unused Docker resources...
docker system prune -f
exit /b

:push
call :build
echo Pushing image %IMAGE_LATEST% to Docker Hub...
docker push %IMAGE_LATEST%
exit /b

:help
echo Available commands:
echo   build              - Build the Docker image (prompts for force rebuild)
echo   clean              - Stop and remove the container if it exists
echo   run                - Build (with prompt), clean, and run the container
echo   stop               - Stop the container without removing it
echo   remove-container   - Remove the container if it exists
echo   prune              - Remove dangling images and volumes
echo   push               - Push the image to Docker Hub
exit /b

