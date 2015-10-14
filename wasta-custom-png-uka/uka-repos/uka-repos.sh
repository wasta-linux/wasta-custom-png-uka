#!/bin/bash

# ==============================================================================
# wasta-custom-png-uka: uka-repos
#
#   This script will ensure the uka ftp servers are listed in /etc/apt/sources.list
#   An option will then be given to the user to enable or disable them.
#
#   2014-01-27 rik: initial script
#   2014-01-28 rik: minor updates
#   2014-05-09 rik: modified to be part of wasta-custom-png-uka instead of
#       wasta-custom-png
#
# ==============================================================================

# ------------------------------------------------------------------------------
# Check to ensure running as root
# ------------------------------------------------------------------------------
#   No fancy "double click" here because normal user should never need to run
#   .desktop launcher will call gksu
if [ $(id -u) -ne 0 ]
then
	echo
	echo "You must run this script with sudo." >&2
	echo "Exiting...."
	sleep 5s
	exit 1
fi

# ------------------------------------------------------------------------------
# Main Processing
# ------------------------------------------------------------------------------

UKA_SOURCES="/usr/share/wasta-custom-png-uka/uka-repos/uka-sources.list"
APT_SOURCES="/etc/apt/sources.list"
MSG=""

# ------------------------------------------------------------------------------
# insert uka-sources.list entries into sources.list
# ------------------------------------------------------------------------------
if ! [ -e "$UKA_SOURCES" ];
then
    zenity --error --title "Ukarumpa Software Sources File NOT Found!" --no-wrap --text \
"<b>Ukarumpa Software Sources File not found!</b>\n
<b>File Missing:</b> $UKA_SOURCES\n
<b>EXITING!</b>"
    exit 1
fi

MSG+="<b>*** Inserting</b> Ukarumpa Software Sources at beginning of
     $APT_SOURCES\n\n"

# Remove sources.list.save if older than 60 days.
find "$APT_SOURCES.save" -mtime +60 -exec rm -f {} \;
# If no existing backup, then backup current sources.list
if ! [ -e "$APT_SOURCES.save" ]; then
  cp "$APT_SOURCES" "$APT_SOURCES.save"
fi;

# REMOVE all ftp.sil.org.pg lines: this way if a line is removed from
#   $UKA_SOURCES it will still be removed from sources.list also.
sed -i -e "\@ftp.sil.org.pg@d" "$APT_SOURCES"

# Loop through uka-sources.list BACKWARDS, inserting into sources.list
tac "$UKA_SOURCES" | while read -r LINE
do
    # Trim leading whitespace
    LINE="${LINE##*( )}"
    # trim trailing whitespace
    LINE="${LINE%%*( )}" 

    # Insert Line if not empty
    if [ -n "$LINE" ];
    then
        # Remove if already found
        sed -i -e "\@$LINE@d" "$APT_SOURCES"

        # Insert at BEGINNING of file
        sed -i -e "1s@^@$LINE\n@" "$APT_SOURCES"
    fi
done

# ------------------------------------------------------------------------------
# Enabling or Disabling uka-sources.list entries
# ------------------------------------------------------------------------------
UKA_SERVERS=$(zenity --list --title "Ukarumpa Software Sources" \
    --text "Do you want to <b>ENABLE</b> or <b>DISABLE</b> the Ukarumpa Software Sources?

If you are <b>NOT</b> at Ukarumpa and <b>ENABLE</b> them, you will receive <b>errors</b>
when you attempt to update your system." --radiolist --height=250 \
    --column "" --column "Action" --column "Description" \
     FALSE      ON                "'ENABLE' Ukarumpa Software Sources"\
     FALSE      OFF               "'DISABLE' Ukarumpa Software Sources")

if [ "$UKA_SERVERS" == "ON" ];
then
    # Don't need to do anything, they are enabled by default from uka-sources.list
    MSG+="<b>*** ENABLING</b> Ukarumpa Software Sources\n\n"
else
    # Disable by commenting out the lines in sources.list
    MSG+="<b>*** DISABLING</b> Ukarumpa Software Sources\n\n"
    echo
    sed -i -e 's@^\(deb ftp://ftp.sil.org.pg\)@#\1@' "$APT_SOURCES"
fi

MSG+="<b>Finished Processing</b>"

# ------------------------------------------------------------------------------
# Finished
# ------------------------------------------------------------------------------
zenity --info --title "Ukarumpa Software Sources" --no-wrap --text "$MSG"

exit 0
