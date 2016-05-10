#!/bin/bash

export LC_ALL=C

aptitude show $(dpkg-query -Wf '${Package}\n') |
  awk '$1 == "Package:"     { name = $2 }
       $1 == "Uncompressed" { printf("%10s %s\n", $3, name) }' |
  awk '$1 ~ /k/ { $1 *= 1 }; $1 ~ /M/ { $1 *= 1024 }
       { printf("%9d %s\n", $1, $2)}'