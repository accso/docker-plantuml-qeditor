#! /bin/sh
USER_HOME=/home/$DOCKER_USER

echo "Mapping UID $TARGET_UID and GID $TARGET_GID for container user $DOCKER_USER..."
sed -i s/$DOCKER_USER:x:1000:1000/$DOCKER_USER:x:$TARGET_UID:$TARGET_GID/ /etc/passwd

echo "Mapping UID and GID in files..."
chown $DOCKER_USER.$DOCKER_USER /home/$DOCKER_USER

echo "Using $DISPLAY for contacting X server..."
SCRIPT=$USER_HOME/start.sh
echo "#!/bin/sh" > $SCRIPT
echo "export DISPLAY=$DISPLAY" >> $SCRIPT
echo "export QT_GRAPHICSSYSTEM=opengl"  >> $SCRIPT
echo "cd /opt/run" >> $SCRIPT
echo "./plantumlqeditor $PLANTUML_FILE" >> $SCRIPT
chmod +x $SCRIPT

CONF_DIR=$USER_HOME/.config/
FILE=$CONF_DIR/QtProject.conf
if [ ! -f $CONF_DIR/QtProject.conf ] ; then
    echo "Installing initial configuration file $FILE..."
    cp /opt/etc/QtProject.conf $CONF_DIR/QtProject.conf
fi
FILE=$CONF_DIR/PlantUML\ Editor/PlantUML\ Editor.conf
if [ ! -f "$FILE" ] ; then
    echo "Installing initial configuration file $FILE..."
    mkdir -p $CONF_DIR/PlantUML\ Editor
    cp /opt/etc/PlantUMLEditor.conf "$FILE"
fi
echo "Starting editor..."
su - plantuml -c $SCRIPT


