#!/bin/bash

# ==============================================================================
# wasta-custom-png-uka-postinst.sh
#
#   This script is automatically run by the postinst configure step on
#       installation of wasta-custom-png-uka. It can be manually re-run, but
#       is only intended to be run at package installation.  
#
#   2014-04-25 rik: initial script
#   2015-10-14 rik: wasta-menus setup using update-alternatives
#
# ==============================================================================

# ------------------------------------------------------------------------------
# Check to ensure running as root
# ------------------------------------------------------------------------------
#   No fancy "double click" here because normal user should never need to run
if [ $(id -u) -ne 0 ]
then
	echo
	echo "You must run this script with sudo." >&2
	echo "Exiting...."
	sleep 5s
	exit 1
fi

# ------------------------------------------------------------------------------
# Initial Setup
# ------------------------------------------------------------------------------

echo
echo "*** Beginning wasta-custom-png-uka-postinst.sh"
echo

# Setup Diretory for later reference
DIR=/usr/share/wasta-custom-png-uka

# ------------------------------------------------------------------------------
# Dconf / Gsettings Default Value adjustments
# ------------------------------------------------------------------------------
echo
echo "*** Updating dconf / gsettings default values"
echo

# Values in /usr/share/glib-2.0/schemas/z_20_wasta-custom-xyz.gschema.override
#   will override Mint defaults.  Below command compiles them to be the defaults
#   for the current machine.
#
# '|| true;' sends any "error" to null (for Cinnamon 1.8-, will get error that some
#   org.cinnamon.muffin key not found, but will not cause a problem, so
#   suppressing errors to not worry user.)

glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true;

# ------------------------------------------------------------------------------
# Configuring Wasta Menus Default Apps
# ------------------------------------------------------------------------------
echo
echo "*** Installing wasta-menus-default-apps.txt in update-alternatives system"
echo
#   Use priority 20 so that will override defaults wasta-menus defaults (10)
update-alternatives --install /etc/wasta-menus-default-apps.txt \
    wasta-menus-default-apps $DIR/resources/wasta-menus-default-apps.txt 20

# ------------------------------------------------------------------------------
# Finished
# ------------------------------------------------------------------------------

echo
echo "*** Finished with wasta-custom-png-uka-postinst.sh"
echo

exit 0
