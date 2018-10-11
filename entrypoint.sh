#!/bin/bash

cd ~

#Check if this is the first time this container ran
if [ ! -f .first_execution ]; then
	echo "This is the first time this container gets executed, so we will install the dependencies and main app..."

	#Create file so next time container runs, this won't get executed again
	touch .first_execution

	#Clone APP repository using GIT
	echo "Cloning app through git..."
	git clone $GIT_REPOSITORY $APP_NAME

	#Install API python requirements through PIP
	echo "Installing app dependencies through pip..."
	pip install --user --upgrade -r $APP_NAME/requirements.txt

	echo "All requirements installed! We are ready to run the app!"

fi

#Start the app
echo "Starting the app..."
python $APP_NAME
