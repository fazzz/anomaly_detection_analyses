#!/usr/local/bin/gnuplot

#set terminal postscript eps enhanced background rgb 'white' color size 10cm , 6cm  "Times" 20
set terminal postscript eps enhanced background rgb 'white' color size 10cm , 4cm  "Times" 20
set output "rmsf.eps"

set encoding iso_8859_1

set tics out

set tics font "Times-Roman,20"
set xlabel font "Times-Roman,24"
set ylabel font "Times-Roman,24"
set label font "Times-Roman,24"
set key font "Times-Roman,20"

set xlabel "Index of Residue"
set ylabel "RMSF (\305)" offset +1,0 

xmin=0
xmax=165
set xtics 10,20,160
set xrange [xmin:xmax]

ymin=0.0
ymax=5.0
set ytics 0.0,1.0,6.0
set yrange [ymin:ymax]

plot "rmsf.xvg"  u 1:($2*10) w l lw 2 lc rgb "red" notitle

quit
