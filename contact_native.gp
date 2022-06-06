#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 10cm, 10cm  "Times" 20
set output "contact.eps"

set encoding iso_8859_1
set tics out
set grid
set size square

set tics   font "Times-Roman,20"
set xlabel font "Times-Roman,24"
set ylabel font "Times-Roman,24"
set label  font "Times-Roman,24"
set key    font "Times-Roman,20"

set xlabel "Index of Residue"
set ylabel "Index of Residue" offset +1,0 

xmin=1
xmax=164
set xtics 10,20,160
set xrange [xmin:xmax]
set mxtics 1

ymin=1
ymax=164
set ytics 10,10,160
set yrange [ymin:ymax]
set mytics 1

f(x) = x
g(x) = x + 5

plot "contact_native.txt" u 1:2 w p pt  7 ps 2.0 lc rgb "red"   notitle, \
     f(x) lw 2.0 lc rgb "black" w l notitle, \
     g(x) lw 4.0 lc rgb "black" w l notitle
