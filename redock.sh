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
TMPERR=redock_err    # Error reporting Dir


# Create Working Dir
if [ ! -d "$WPDIR" ]; then
  mkdir -p "$WPDIR"
fi

# Create Error Dir
if [ ! -d "$TMPERR" ]; then
  mkdir -p "$TMPERR"
fi



# #
# Move Files
# #

# WordPress Core
if [ -d wp ]; then
  cp wp/* "$WPDIR"
  # rm -rf wp
fi

# Themes
echo "${GREEN}+ Moving Themes"
cp app/themes/* $WPDIR/wp-content/themes 2>/dev/null

# Plugins
echo "${GREEN}+ Moving Plugins"
cp app/plugins/* $WPDIR/wp-content/plugins 2>/dev/null

# MU-Plugins
echo "${GREEN}+ Moving Must Use Plugins"
mkdir -p $WPDIR/wp-content/mu-plugins
cp app/mu-plugins/* $WPDIR/wp-content/mu-plugins 2>/dev/null

# Uploads
echo "${GREEN}+ Moving Uploads"
mkdir -p "$WPDIR/wp-content/uploads"
cp app/uploads/* "$WPDIR/wp-content/uploads" 2>/dev/null


# #
# Move and Update config files
# #

# Apollo Configurations
if [ -f lib/config/"apollo-config.php" ]; then
  cp lib/config/"apollo-config.php" "$WPDIR"
fi

# wp-config
if [ -f "wp-config.php" ]; then
  cp "wp-config.php" "$WPDIR"
fi

cd "$WPDIR"

# Update wp-config require
OLDREQ="lib\/config\/apollo-config.php"
NEWREQ="apollo-config.php"

if [ -f "apollo-config.php" ] && [ -f "wp-config.php" ]; then
  sed "s/$OLDREQ/$NEWREQ/g" "wp-config.php" > "wp-config.php"
fi







echo $PWD

echo "Conversion Complete!"

