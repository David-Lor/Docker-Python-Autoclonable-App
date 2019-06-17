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
    rm -rf keys
    rm -rf ${APP_NAME}
    checkExitCode

    # Fetch private key if exists
    if [[ ! -z ${SSH_KEY} ]]; then
        # Save base64 Key on a file
        echo "SSH Key detected"
        mkdir keys
        echo "${SSH_KEY}" > keys/ssh_key.base64
        checkExitCode

        # Decode the base64 Key and save decoded on a file
        echo "Decoding base64 SSH key..."
        base64 -d -i keys/ssh_key.base64 > keys/ssh_key
        checkExitCode

        # Set proper permissions to the key
        chmod 600 keys/ssh_key
    fi

    # Get GIT Branch option if exists
    if [[ ! -z ${GIT_BRANCH} ]]; then
        git_branch_options=(--branch ${GIT_BRANCH})
    fi

    # Clone APP repository using GIT
    if [[ -z ${SSH_KEY} ]]; then
        # Without SSH
        echo "Cloning app through git..."
        git clone --branch ${GIT_BRANCH} ${GIT_REPOSITORY} ${APP_NAME}
        checkExitCode
    else
        # With SSH
        echo "Cloning app through git+ssh..."
        GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i keys/ssh_key" git clone ${GIT_REPOSITORY} ${APP_NAME}
        checkExitCode
        # Remove SSH keys after successful clone
        rm -rf keys
        checkExitCode
    fi

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
