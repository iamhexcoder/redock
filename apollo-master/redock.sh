#!/bin/bash

# Abort if the app directory does not exist
if [ ! -d app ]; then
  echo "Aborting...This does not appear to be an Apollo configuration."
  echo "${PURPLE}Error: ${WHITE}Missing ${RED}/app ${WHITE}directory."
  exit
fi

# Start Conversion
echo "Starting Conversion"


WPDIR=redock_temp    # Working Dir


# Create Working Dir
if [ ! -d $WPDIR ]; then
  mkdir -p $WPDIR
fi


# Read JSON Function
# Thanks to http://dailyraisin.com/read-json-value-in-bash/
function readJson {
  UNAMESTR=`uname`
  if [[ "$UNAMESTR" == 'Linux' ]]; then
    SED_EXTENDED='-r'
  elif [[ "$UNAMESTR" == 'Darwin' ]]; then
    SED_EXTENDED='-E'
  fi;

  VALUE=`grep -m 1 "\"${2}\"" ${1} | sed ${SED_EXTENDED} 's/^ *//;s/.*: *"//;s/",?//'`

  if [ ! "$VALUE" ]; then
    echo "Error: Cannot find \"${2}\" in ${1}" >&2
    exit 1
  else
    echo $VALUE
  fi
}

# Download Latest Version of WordPress
# Get version from composer.json, download it from WP, unzip it, and move its
# contents up one dir to the temp folder, remove wordpress dir and .zip
WPVER=`readJson composer.json johnpbloch/wordpress`
WPFILE="wordpress-$WPVER.zip"
WPDLBASE="https://wordpress.org/"
WPDL=$WPDLBASE$WPFILE

cd $WPDIR

# curl -O $WPDL

# unzip $WPFILE

# rm $WPFILE

cd -

# mv "$WPDIR"/wordpress/* "$WPDIR"

# MOVE ALL THEMES
echo "${GREEN}Moving Themes"
mv app/themes/* $WPDIR/wp-content/themes

# MOVE ALL PLUGINS
echo "${GREEN}Moving Plugins"
mv app/plugins/* $WPDIR/wp-content/plugins

# MOVE ALL MU-PLUGINS
echo "${GREEN}Moving Must Use Plugins"
mkdir -p $WPDIR/wp-content/"mu-plugins"
mv app/mu-plugins/* $WPDIR/wp-content/mu-plugins

# MOVE ALL UPLOADS
echo "${GREEN}Moving Uploads"
mkdir -p $WPDIR/wp-content/uploads
mv app/uploads/* $WPDIR/wp-content/uploads

echo $PWD

