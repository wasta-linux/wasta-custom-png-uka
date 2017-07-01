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
# Finished
# ------------------------------------------------------------------------------

echo
echo "*** Finished with wasta-custom-png-uka-postinst.sh"
echo

exit 0
