#!/bin/bash


# Set current dir to variable
startDirectory="$PWD"
startDirectoryName=${PWD##*/}
cd ..
startParentDirectory="$PWD"
cd $startDirectory


# Setup Suffix
suffix="_wp"


# Check flags
while getopts :suffix:h opt; do
  case $opt in
    h)
      echo "-s, --suffix    ${WHITE}Suffix appended target copy directory. ${PURPLE}Default: _wp"
      exit
      ;;
    s)
      suffix="_"${OPTARG//=}
      ;;
  esac
done


# Create Copy Directory - This is the directory where all the goodness goes
REDOCK="$startDirectoryName$suffix"
REDOCKPATH=$startParentDirectory\/$REDOCK;
if [ ! -d $REDOCKPATH ]; then
  mkdir $REDOCKPATH
else
  echo "${PURPLE}Error: ${WHITE}Terminating Redock."
  echo "${WHITE}The directory $REDOCKPATH already exists. Delete the existing $REDOCK and try again."
  exit
fi


# Abort if the app directory does not exist
if [ ! -d app ]; then
  echo "${PURPLE}Error: ${WHITE}Terminating Redock."
  echo "This does not appear to be an Apollo configuration. The ${RED}/app ${WHITE}directory is missing."
  exit
fi

## ----------------
## Start Conversion
## ----------------


echo "${GREEN}Starting Conversion........"


# Move WordPress Core
echo -n "${GREEN}+ Copying WordPress Core${WHITE}"
if cp -R wp/* "$REDOCKPATH"; then
  echo "${WHITE}......Core copied."
else
  echo -e "\n${PURPLE}Error: ${WHITE}Missing ${RED}/wp ${WHITE}directory."
  exit
fi


# Move Themes
echo -n "${GREEN}+ Copying Themes"
if cp -R app/themes/* $REDOCKPATH/wp-content/themes; then
  echo "${WHITE}..............👍  themes copied."
else
  echo "${WHITE}..............👍  no themes to copy."
fi


# Move Plugins
echo -n "${GREEN}+ Copying Plugins"
files=(app/plugins/*)
txt="${WHITE}.............👽  No plugins to copy."
if [ ${#files[@]} -gt 0 ]; then
  rm -rf $REDOCKPATH/wp-content/plugins/*  2> /dev/null   # empty plugins folder first
  if  cp -R app/plugins/* $REDOCKPATH/wp-content/plugins 2>>/dev/null
    then echo "${WHITE}.............👍  plugins copied."
  else
    echo "$txt"
  fi
else
  echo "$txt"
fi


# Move MU-Plugins
echo -n "${GREEN}+ Moving MU-Plugins"
files=(app/mu-plugins/*)
txt="${WHITE}...........👽  no plugins to copy."
mkdir -p "$REDOCKPATH/wp-content/mu-plugins" # Make dir in WP
if [ ${#files[@]} -gt 0 ]; then
  if  cp -R app/mu-plugins/* $REDOCKPATH/wp-content/mu-plugins
    then echo "${WHITE}...........👍  mu-plugins copied."
  else
    echo "$txt"
  fi
else
  echo "$txt"
fi


# Move Uploads
echo -n "${GREEN}+ Moving Uploads"
txt="${WHITE}..............👽  no uploads to copy."
mkdir -p $REDOCKPATH/wp-content/uploads
if [ ! -d app/uploads ]; then
  if  cp -R app/uploads/* "$REDOCKPATH/wp-content/uploads"
    then echo "${WHITE}..............uploads copied."
  else
    echo "$txt"
  fi
else
  echo "$txt"
fi

# Move and update wp-config file
echo -n "${GREEN}+ Moving wp-config file"
if [ -f "wp-config.php" ]; then
  # cp "wp-config.php" $REDOCKPATH
  start='\/\*\* Start Apollo Config \*\/';
  end='\/\*\* End Apollo Config \*\/';
  sed -i.tmp "/$start/,/$end/d" wp-config.php
  mv wp-config.php.tmp $REDOCKPATH/wp-config.php
  echo "${WHITE}.......👍  wp-config.php file copied and apollo config removed"
else
  echo -e "\n${PURPLE}ERROR: ${WHITE}no wp-config.php file to copy."
  exit
fi

# Remove composer related files
echo -n "${GREEN}- Remove composer files"
if [ -f $REDOCKPATH/composer.json ]; then
  rm $REDOCKPATH/composer.json
fi
if [ -f $REDOCKPATH/composer.lock ]; then
  rm $REDOCKPATH/composer.lock
fi
echo "${WHITE}.......👍  composer files removed"


# All Done!
echo "🚀  ${PURPLE}Conversion Complete! ${WHITE}The directory $REDOCKPATH is now a standard WordPress install."
echo "${WHITE}Be sure to review the install. If you had custom packages in $startDirectory/lib, they will need to be manually moved and relinked."

