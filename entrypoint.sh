#!/bin/bash

cd ~

checkExitCode() {
    exitcode=$?
    if [[ ${exitcode} -ne 0 ]]; then
        echo "Previous command failed with exit code ${exitcode}, container will stop now!"
        exit ${exitcode}
    fi
}


#Check if this is the first time this container ran
if [[ ! -f .first_execution ]]; then
    echo "This is the first time this container gets executed, so we will install the dependencies and main app..."

    # Clear output directory if exists
    echo "Cleaning output directory..."
    rm -rf ${APP_NAME}
    checkExitCode

    # Clone APP repository using GIT
    echo "Cloning app through git..."
    git clone ${GIT_REPOSITORY} ${APP_NAME}
    checkExitCode

    # Install API python requirements through PIP
    echo "Installing app dependencies through pip..."
    pip install --user --upgrade -r ${APP_NAME}/requirements.txt
    checkExitCode

    # Create file so next time container runs, this won't get executed again
    # (only if all the previous commands were executed successfully, otherwise the container should be stopped)
    touch .first_execution

    echo "All requirements installed! We are ready to run the app"

fi

#Start the app
echo "Starting the app now!"
python -u ${APP_NAME}
