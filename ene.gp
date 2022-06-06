#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 9cm, 5cm  "Times" 20
set output "ene.eps"

set encoding iso_8859_1

set tics out

set tics   font "Times-Roman,16"
set xlabel font "Times-Roman,16"
set ylabel font "Times-Roman,16"
set label  font "Times-Roman,16"
set key    font "Times-Roman,16"

set xlabel "Times (ns)"
set ylabel "E (100kJ/mol)" offset +1,0 

plot "eneres_scaled/ene_all.txt" u ($0/10):($1/100) w l lw 1.2 lc rgb "red" notitle

quit
