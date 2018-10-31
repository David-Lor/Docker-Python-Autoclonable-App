FROM python:latest

#ENV variables
ENV GIT_REPOSITORY null
ENV APP_NAME MyApp

#Upgrade PIP
RUN pip install --user --upgrade pip

#Copy the Entrypoint script and make it executable
COPY entrypoint.sh entrypoint.sh
RUN chmod u+x entrypoint.sh

#Execute the entrypoint
CMD ["./entrypoint.sh"]
