# Docker-Python-Autoclonable-App

A Python Docker that downloads a Git repository with whatever project you want when a container runs for the first time

## Objective

Run a Python app that is hosted on any Git repository, without having to create a specific Docker image for that project and version.

This image lets you create a container, setting during the container creation process the URL of the Git repository the project is hosted on.

## Advantages

One single image lets you run any number of Python projects, without having to build one image per project. The latest/wanted version of that project is cloned during the first execution of the container trough Git. Any update on the project can be downloaded by just rebuilding the container.

## How does it work?

When you create a new container and properly set the Git URL (using the `GIT_REPOSITORY` ENV), during the first execution, the entrypoint bash script will clone that repository to your container, install all the Python requirements through pip, and start it.

After this first startup, whenever the container is started, a hidden file will tell the entrypoint script that the container has been executed for the first time before, and won't clone the app through Git, just starting it.

App runs with a new user created on Dockerbuild (_appuser_ by default), so the app won't run with root privileges (if you want to run with root, check out the [Run as root](https://github.com/EnforcerZhukov/Docker-Python-Autoclonable-App/blob/master/README.md#run-as-root). Everything is intended to live within /home directory of this user, so keep this in mind when you want to bind/mount a data volume for persistence.

## How to deploy?

```bash
docker run -d -p <desired>:<ports> \
-e GIT_REPOSITORY:<url to a Git repository> \
--name <containerName> \
davidlor/python-autoclonable-app
```

## ENV Variables & ARGs

* (ARG) `USERNAME`: name of the user that is created on Dockerbuild to run the app with (optional, default: _appuser_)
* `GIT_REPOSITORY`: URL of the remote Git repository to get the app from (required)
* `APP_NAME`: name of your app. This name is given to the directory where project is cloned on (optional, default: _MyApp_)

Only required variable is (ENV) `GIT_REPOSITORY`.

## Python Project structure

The entrypoint script expects the cloned Python app to have the following structure:

```
ProjectRoot (cloned through Git)
│   __main__.py
|   requirements.txt (if required)
│   ...and all the other project files
```

## Run as root

Use the tag `root` instead of latest:

```bash
docker run [...] davidlor/python-autoclonable-app:root
```

Source files of `root` tag are available on the [root branch](https://github.com/EnforcerZhukov/Docker-Python-Autoclonable-App/tree/root).

## How to build?

If you want to build this image (required in order to change default username), you must do on host machine:

* Clone this repository
* Build a new Docker image using the repository directory
* Create a new container, setting up the desired ENV variables

```bash
git clone https://github.com/EnforcerZhukov/Docker-Python-Autoclonable-App.git DockerPythonApp
docker build DockerPythonApp -t yourname/yourtag:yourversion
docker run ...
```

## TODO

* Allow to have the Python app on any other directory than root
* Check if git clone and Python requirements install were successful
* Allow to change the command to execute after the entrypoint
