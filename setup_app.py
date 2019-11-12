"""SETUP APP Script
"""

import os
import git
from contextlib import suppress
from pip._internal.main import main as pipmain


class Settings:
    FIRST_RUN_FILENAME = ".setup_app_done"
    REQUIREMENTS_FILENAME = "requirements.txt"

    def __init__(self):
        try:
            self.app_name = os.environ["APP_NAME"]
            self.git_repository = os.environ["GIT_REPOSITORY"]
        except KeyError as error:
            print("Error! Environment variable not defined: {}".format(error))
            exit(1)
        self.base_dir = os.path.expanduser("~")
        self.first_run_file = self.join_home(self.FIRST_RUN_FILENAME)
        self.app_dir = self.join_home(self.app_name)
        self.requirements_file = self.join_app(self.REQUIREMENTS_FILENAME)
    
    def join_home(self, path):
        return os.path.join(self.base_dir, path)
    
    def join_app(self, path):
        return os.path.join(self.app_dir, path)


def is_first_run(settings):
    return not os.path.isfile(settings.first_run_file)


def save_setup_done(settings):
    os.mknod(settings.first_run_file)
    print("Saved 'App installed' status")


def clear_output_dir(settings):
    with suppress(FileNotFoundError):
        os.rmdir(settings.app_dir)
        print("Cleared output directories")


def clone(settings):
    print("Cloning app through Git...")
    # TODO Clone specific branch | or use subprocess
    git.Repo.clone_from(url=settings.git_repository, to_path=settings.app_dir)
    print("App cloned through Git!")


def install_requirements(settings):
    if os.path.isfile(settings.requirements_file):
        print("Installing requirements through Pip...")
        pipmain(["install", "--user", "-r", settings.requirements_file])
        # TODO errors during install do not raise exception?
        print("Requirements installed through Pip!")
    else:
        print("No requirements.txt file found")


if __name__ == "__main__":
    settings = Settings()
    args = (settings,)

    if is_first_run(*args):
        print("This is container first run, running app installing process...")
        clear_output_dir(*args)
        clone(*args)
        install_requirements(*args)
        save_setup_done(*args)
    else:
        print("App already installed")
