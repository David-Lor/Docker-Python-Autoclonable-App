# ARG variables
ARG USERNAME=appuser
ARG IMAGE_TAG=latest

# Base image (tag from ARG)
FROM python:$IMAGE_TAG

# ENV variables
ENV GIT_REPOSITORY ""
ENV APP_NAME MyApp
ENV SSH_KEY ""
ENV GIT_BRANCH ""

# Add a non-root user
RUN useradd -ms /bin/bash $USERNAME

# Copy the Entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
COPY setup_app.py /setup_app.py
RUN chmod u+x entrypoint.sh

# Change user and directory
USER $USERNAME
WORKDIR /home/$USERNAME

# Upgrade PIP
RUN pip install --user --upgrade pip

# Execute the entrypoint
CMD ["/entrypoint.sh"]
