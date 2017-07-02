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

# Setup Directory for later reference
DIR=/usr/share/wasta-custom-png-uka

# ------------------------------------------------------------------------------
# Dconf / Gsettings Default Value adjustments
# ------------------------------------------------------------------------------
# Override files in /usr/share/glib-2.0/schemas/ folder.
#   Values in z_30_wasta-custom-png-boug.gschema.override will override values
#   in z_10_wasta-base-setup.gschema.override which will override Mint defaults.
echo
echo "*** Updating dconf / gsettings default values"
echo
# Sending any "error" to null (if a key isn't found it will return an error,
#   but for different version of Cinnamon, etc., some keys may not exist but we
#   don't want to error in this case: suppressing errors to not worry user.
glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true;

# ------------------------------------------------------------------------------
# Finished
# ------------------------------------------------------------------------------

echo
echo "*** Finished with wasta-custom-png-uka-postinst.sh"
echo

exit 0
