#!/bin/bash

# Houston        29.76 -95.36
# Atlanta        33.75 -84.39
# Washington     38.90 -77.04
# Johannesburg  -26.20  28.08

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
  $LOC2LOC -n 31.76 -s 27.76 -e -93.36 -w -97.36 -I . -O data -p houston -l $g
  #
  # Atlanta
  #
  $LOC2LOC -n 35.75 -s 31.75 -e -82.39 -w -86.39 -I . -O data -p atlanta -l $g
  #
  # Washington DC
  #
  $LOC2LOC -n 40.90 -s 36.90 -e -75.04 -w -79.04 -I . -O data -p washington -l $g
  #
  # Johannesburg
  #
  $LOC2LOC -n -24.20 -s -28.20 -e 30.08 -w 26.08 -I . -O data -p johannesburg -l $g
  #
  rm -f $g
done