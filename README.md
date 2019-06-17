# Docker-Python-Autoclonable-App

🐍 🐳 A Docker that downloads a Git repository with a Python app you want to deploy when a container runs for the first time

DockerHub: https://hub.docker.com/r/davidlor/python-autoclonable-app/

## Objective

Run a Python app that is hosted on any Git repository, without having to create a specific Docker image for that project and version.

This image lets you create a container, setting during the container creation process the URL of the Git repository the project is hosted on.

## Advantages

One single image lets you run any number of Python projects, without having to build one image per project. The latest/wanted version of that project is cloned during the first execution of the container trough Git. Any update on the project can be downloaded by just rebuilding the container.

## How does it work?

When you create a new container and properly set the Git URL (using the `GIT_REPOSITORY` ENV), during the first execution, the entrypoint bash script will clone that repository to your container, install all the Python requirements through pip, and start it.

After this first startup, whenever the container is started, a hidden file will tell the entrypoint script that the container has been executed for the first time before, and won't clone the app through Git, just starting it.

App runs with a new user created on Dockerbuild (_appuser_ by default), so the app won't run with root privileges (if you want to run with root, check out the [Run as root](https://github.com/David-Lor/Docker-Python-Autoclonable-App#run-as-root). Everything is intended to live within /home directory of this user, so keep this in mind when you want to bind/mount a data volume for persistence.

## How to deploy?

```bash
docker run -d -p <desired>:<ports> \
-e GIT_REPOSITORY=<url to a Git repository> \
--name <containerName> \
davidlor/python-autoclonable-app
```

## Deploy using SSH

If the repository is private and can be cloned using SSH instead of HTTP/S, then you must provide the SSH Private Key to the container through a ENV Variable, but encoded in Base64. **The SSH Key must have no passphrase**

You can take advantage of private Github repositories and clone them as a container using this image. Just set a Deploy Key on your repository settings ([learn more](https://gist.github.com/zhujunsan/a0becf82ade50ed06115))

Use the b64encode.sh script to encode your key. This will output a file with the .base64 extension, which content is used as the `SSH_KEY` ENV variable on your container.

```bash
chmod u+x b64encode.sh
./b64encode.sh your_private_key
# A file named 'your_private_key.base64' is generated. You can pass the content directly to docker run:
docker run -d -p <desired>:<ports> \
-e GIT_REPOSITORY=<SSH url to a Git repository> \
-e SSH_KEY="$(cat your_private_key.base64)" \
--name <containerName> \
davidlor/python-autoclonable-app
```

## ENV Variables & ARGs

* `GIT_REPOSITORY`: URL of the remote Git repository to get the app from (required)
* `GIT_BRANCH`: set the Branch to clone from the Git repository (optional, default: none - use Git default branch)
* `SSH_KEY`: SSH private key, base64 encoded. Required if a SSH git repository is provided. **The SSH Key must have no passphrase** (optional, default: none)
* `APP_NAME`: name of your app. This name is given to the directory where project is cloned on (optional, default: _MyApp_)
* (ARG) `USERNAME`: name of the user that is created on Dockerbuild to run the app with (optional, default: _appuser_)

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

Source files of `root` tag are available on the [root branch](https://github.com/David-Lor/Docker-Python-Autoclonable-App/tree/root).

## How to build?

If you want to build this image (required in order to change default username), you must do on host machine:

* Clone this repository
* Build a new Docker image using the repository directory (optionally set a custom username using the `USERNAME` ARG)
* Create a new container, setting up the desired ENV variables

```bash
git clone https://github.com/David-Lor/Docker-Python-Autoclonable-App.git DockerPythonApp
docker build DockerPythonApp --build-arg USERNAME=<desiredUser> -t yourname/yourtag:yourversion
docker run [...] yourname/yourtag:yourversion
```

## Changelog

- 0.0.1: Initial release.
- 0.1.1: Check Exit code after each command executed on the entrypoint. If some part fails, the container will stop.
- 0.2.1: Option to provide a SSH private key through ENV (encoded in base64).
- 0.2.2: Option to set the GIT Branch to clone

## TODO

* Allow to have the Python app on any other directory than root
* ~~Check if git clone and Python requirements install were successful~~
* Allow to change the command to execute after the entrypoint
