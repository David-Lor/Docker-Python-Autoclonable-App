FROM python:latest

#ENV variables
ENV GIT_REPOSITORY null
ENV APP_NAME MyApp
ARG USERNAME=appuser

#Add a non-root user
RUN useradd -ms /bin/bash $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

#Upgrade PIP
RUN pip install --user --upgrade pip

#Clone API repository using Git
#This is done on entrypoint.sh
#git clone $GIT_REPOSITORY $APP_NAME

#Install API python requirements through PIP
#This is done on entrypoint.sh
#RUN pip install --user --upgrade -r $APP_NAME/requirements.txt

#Copy the Entrypoint script and make it executable
USER root
COPY entrypoint.sh entrypoint.sh
RUN chown $USERNAME entrypoint.sh
USER $USERNAME
RUN chmod u+x entrypoint.sh

#Execute the entrypoint
CMD ["./entrypoint.sh"]

