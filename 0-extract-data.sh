#!/bin/bash

# Houston        29.76 -95.36
# Atlanta        33.75 -84.39
# Washington     38.90 -77.04
# Johannesburg  -26.20  28.08

LOC2LOC=$HOME/bin/loc2loc

DATADIR=/media/colliera/8396dee6-3b86-4313-bb77-27c78b796c9e/wwlln/

rm -f data/*.loc

for f in $DATADIR/A200[456789]????.loc $DATADIR/A201[01234]????.loc
do
  g=`basename $f .bz2`
  #
  echo $g
  #
  cp $f $g
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
  # Bloemfontein
  #
  $LOC2LOC -n -26.12 -s -32.12 -e 29.22 -w 23.22 -I . -O data -p bloemfontein -l $g
  #
  # Durban
  #
  $LOC2LOC -n -26.88 -s -32.88 -e 34.05 -w 28.05 -I . -O data -p durban -l $g
  #
  # Cape Town
  #
  $LOC2LOC -n -30.92 -s -36.92 -e 21.42 -w 15.42 -I . -O data -p capetown -l $g
  #
  rm -f $g
done
