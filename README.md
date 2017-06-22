# docker-plantuml-qeditor
This is a Docker container based on Debian Duster with PLANT-UML and QEditor installed.

## GUI

The container uses the approach of letting the application communicate with the X server running on the host by using specific X11 files located on the host server. The application can be started as though it were residing on the host server. The mounted files and directories are as follows:

 * `/tmp/.X11-unix`
 * `/etc/machine-id`
 * `/usr/share/X11/xkb`
 * `$HOME/.Xauthority`

## Accessing Plant-UML files from outside the container

The aim of the container is to let the user consistently read and write Plant-UML files located on the host server without having to worry about mismatching UID or GID. In order to achieve this the following measures have been taken:

 * provide a user (`plantuml`) in the container and run the application using that user and its default group,
 * dynamically change the UID of that user and the GID of its group to match the UID and GID of the host user starting the container,
 * add the username of the calling user to the container name so that possible several users can call the run script and have seperate containers without collision,
 * map the home directory of the calling user as `home_on_host` in the home directory of user `plantuml`,
 * map the path of a PlantUML file passed as parameter to the run script to the mounted path inside the container,
 * the `$HOME/.config` directory of the container will be mapped onto the directory `$HOME/.docker_qt_config` of the calling user to persist configuration changes across container instances.
 
## Usage

On a linux system just copy the [run.sh](bin/run.sh) to your local file system, make it executable and run it. Optionally, you can pass athe file path of a Plant-UML file as a single parameter. Use the script [build.sh](bin/build.sh) to build the container locally after cloning https://github.com/accso/docker-plantuml-qeditor.

## Dockerfile

The [Dockerfile](Dockerfile) executes the following steps:

 * retrieve the Plant-UML JAR from the [project website](http://plantuml.com/),
 * retrieve the sources of the QEditor as ZIP from the [project GitHub site](https://github.com/borco/plantumlqeditor),
 * compile and install the application.
 
## Caveats

Currently, these are the known bugs:

 * Most menu icons won't appear. Instead the application will be using normal text labels. This seems to be related to the load mechanism which retrives icons based on an installed theme.
 * Sometimes some of the dropdown menus (usually "Edit" and "Settings") are bit-scrambled. Closing and re-opening usually does *not* fix the problem.
 * During startup, the system complains about DRI* nor being supported or not beging authenticated. This error does not seem to matter, but it does not appear in a native setup (outside a Docker container) either.
 * There are repeated messages about negative sizes in function `QWidget::setMinimumSize` which apparently can be ignored.
 * Sometimes, modal windows (e.g. "About" and "About qt") are bit-scrambled. Closing and re-opening usually fixes the problem.

Any help with these problems are appreciated!
