ARG IMAGE_TAG=latest
FROM python:$IMAGE_TAG

# ENV variables
ENV GIT_REPOSITORY ""
ENV APP_NAME MyApp
ENV GIT_BRANCH ""
ARG USERNAME=appuser

# Add a non-root user
RUN useradd -ms /bin/bash $USERNAME || (addgroup $USERNAME && adduser $USERNAME -D -G $USERNAME)

# Copy entrypoint & setup scripts, change ownership, set executable
COPY entrypoint.sh /home/$USERNAME/entrypoint.sh
COPY setup_app.py /home/$USERNAME/setup_app.py
# TODO scripts should be readable but not writable by the user?
RUN chown $USERNAME:$USERNAME /home/$USERNAME/entrypoint.sh /home/$USERNAME/setup_app.py
RUN chmod u+x /home/$USERNAME/entrypoint.sh

# Install git if not installed
# TODO Add no-cache/lightweight options
RUN which git || ((apt-get update && apt-get -y install git) || (apk update && apk add git))

# Change user and working directory
USER $USERNAME
WORKDIR /home/$USERNAME

# Upgrade PIP and install dependencies
# TODO Add no-cache/lightweight options
RUN pip install --user --upgrade pip

# Execute the entrypoint
CMD ["./entrypoint.sh"]
