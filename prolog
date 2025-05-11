#!/bin/bash
##### Loop through a Flux directory and attempt to run all executable scripts  #####
#####            /etc/flux/system/prolog     for    /etc/flux/system/prolog.d  #####

SCRIPT=""

for SCRIPT in /etc/flux/system/prolog.d; do 
	echo "Running: "$SCRIPT
	/etc/flux/system/prolog.d/$SCRIPT
done
