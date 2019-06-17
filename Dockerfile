FROM python:latest

#ENV variables
ENV GIT_REPOSITORY ""
ENV APP_NAME MyApp
ENV SSH_KEY ""
ENV GIT_BRANCH ""
ARG USERNAME=appuser

#Add a non-root user
RUN useradd -ms /bin/bash $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

#Upgrade PIP
RUN pip install --user --upgrade pip

#Copy the Entrypoint script and make it executable
USER root
COPY entrypoint.sh entrypoint.sh
RUN chown $USERNAME entrypoint.sh
USER $USERNAME
RUN chmod u+x entrypoint.sh

#Execute the entrypoint
CMD ["./entrypoint.sh"]

