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
  $LOC2LOC -n 30.75 -s 29.15 -e -94.45 -w -96.15 -I . -O data -p houston -l $g
  #
  # Atlanta
  #
  $LOC2LOC -n 34.555 -s 32.955 -e -83.54 -w -85.24 -I . -O data -p atlanta -l $g
  #
  # Washington DC
  #
  $LOC2LOC -n 39.695 -s 38.095 -e -76.187 -w -77.887 -I . -O data -p washington -l $g
  #
  rm -f $g
done