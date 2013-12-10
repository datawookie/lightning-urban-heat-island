#!/bin/bash

# Houston        29.76 -95.36
# Atlanta        33.75 -84.39
# Washington     38.90 -77.04
# Johannesburg  -26.20  28.08

LOC2LOC=$HOME/bin/loc2loc

DATADIR=/media/8396dee6-3b86-4313-bb77-27c78b796c9e/wwlln/

for f in $DATADIR/A201[012]????.loc.bz2
do
  g=`basename $f .bz2`
  #
  echo $g
  #
  bunzip2 -dc $f >$g
  #
  # Houston
  #
  $LOC2LOC -n 32.76 -s 26.76 -e -92.36 -w -98.36 -I . -O data -p houston -l $g
  #
  # Atlanta
  #
  $LOC2LOC -n 36.75 -s 30.75 -e -81.39 -w -87.39 -I . -O data -p atlanta -l $g
  #
  # Washington DC
  #
  $LOC2LOC -n 41.90 -s 35.90 -e -74.04 -w -80.04 -I . -O data -p washington -l $g
  #
  # Johannesburg
  #
  $LOC2LOC -n -23.20 -s -29.20 -e 31.08 -w 25.08 -I . -O data -p johannesburg -l $g
  #
  rm -f $g
done