#!/bin/bash

LOC2LOC=$HOME/bin/loc2loc

DATADIR=/media/8396dee6-3b86-4313-bb77-27c78b796c9e/wwlln/

for f in $DATADIR/A2011????.loc.bz2
do
  g=`basename $f .bz2`
  #
  bunzip2 -dc $f >$g
  #
  # Houston
  #
  $LOC2LOC -n 31.75 -s 28.15 -e -93.45 -w -97.15 -I . -O data -p houston -l $g
  #
  # Atlanta
  #
  $LOC2LOC -n 35.555 -s 31.955 -e -82.54 -w -86.24 -I . -O data -p atlanta -l $g
  #
  # Washington DC
  #
  $LOC2LOC -n 40.695 -s 37.095 -e -75.187 -w -78.887 -I . -O data -p washington -l $g
  #
  rm -f $g
done