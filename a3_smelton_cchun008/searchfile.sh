#! /bin/sh
if egrep "$1" "$2" > /dev/null
then
	echo "$2" >> listfiles.output
fi
