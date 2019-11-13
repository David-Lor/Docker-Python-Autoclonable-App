# Docker-Python-Autoclonable-App

🐍🐳 A Docker image that downloads a Git repository with a Python app you want to deploy when the container runs for the first time

[DockerHub](https://hub.docker.com/r/davidlor/python-autoclonable-app/)

## Objective

Run a Python app that is hosted on any Git repository, without having to create a specific Docker image for that project and version.

This means that one single image let you run any(1) Python project, without having to build one image per project.
The latest/wanted version of that project is cloned during the first execution of the container trough Git.
Any update on the project can be downloaded by just rebuilding the container.

(1) The project must follow a structure in order for the entrypoint to run it (see [Python Project structure](#python-project-structure)).

## Changelog

- 1.0.1 - Rewrite Dockerfile (__NOT DEPLOYED YET to DockerHub!__):
    - Python setup script
    - Change Python base image tag through ARG
- 0.2.2 - Option to set the GIT Branch to clone
- 0.2.1 - Option to provide a SSH private key through ENV (encoded in base64).
- 0.1.1 - Check Exit code after each command executed on the entrypoint. If some part fails, the container will stop.
- 0.0.1 - Initial release.

## How does it work

When you create a new container and properly set the Git URL (using the `GIT_REPOSITORY` ENV), during the first execution, 
the entrypoint bash script will clone the repository in your container, install all the Python requirements through pip, 
and start it. After this first startup, the next time/s the container starts, the setup process is skipped.

App runs with a new user created on Dockerbuild (_appuser_ by default), so the app won't run with root privileges.

## How to deploy

```bash
docker run -d -e GIT_REPOSITORY=<url to a Git repository> --name <containerName> davidlor/python-autoclonable-app
```

## ENV Variables & ARGs

- `GIT_REPOSITORY`: URL of the remote Git repository to get the app from (required)
- `GIT_BRANCH`: set the Branch to clone from the Git repository (optional, default: use default branch)
- `APP_NAME`: name of your app. This name is given to the directory where project is cloned on (optional, default: _MyApp_)
- (ARG) `USERNAME`: name of the user that is created on Dockerbuild to run the app with (optional, default: _appuser_)
- (ARG) `IMAGE_TAG`: tag of the [Python base image](https://hub.docker.com/_/python/) to be used for the build (optional, default: _latest_)

Only required variable is (ENV) `GIT_REPOSITORY`. The variables marked with (ARG) are [build-args](https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables---build-arg).

## Python Project structure

The entrypoint script expects the cloned Python app to have the following structure:

```txt
ProjectRoot (cloned through Git)
│-  __main__.py
|-  requirements.txt (if required)
│-  ...and all the other project files/directories
```

Some examples of projects compliant with this structure are:

- [Python-HelloWorld](https://github.com/David-Lor/Python-HelloWorld) (used as Git repository for testing this image)
- [MQTT2ETCD](https://github.com/David-Lor/MQTT2ETCD)
- [VigoBusAPI](https://github.com/David-Lor/Python_VigoBusAPI)

## How to build

If you want to build this image (required in order to change default username or base image tag), you must do on host machine:

- Clone this repository
- Build a new Docker image using the repository directory - you can optionally set these ARGs:
    - a custom username using the `USERNAME` ARG
    - a custom [Python base image](https://hub.docker.com/_/python/) tag using the `IMAGE_TAG` ARG (example: `alpine` or `slim`)
- Create a new container, setting up the desired ENV variables

```bash
git clone https://github.com/David-Lor/Docker-Python-Autoclonable-App.git DockerPythonApp
docker build DockerPythonApp --build-arg USERNAME=<desiredUser> -t yourname/yourtag:yourversion
docker run [...] yourname/yourtag:yourversion
```

## TODO

- Run as root with a env variable - or another image tag
- Load SSH key from directory for cloning SSH git repositories
- Catch errors while installing requirements through Pip
- Create Github Actions to build and push multiple tags to DockerHub (if possible all the tags available on the Python base image)
