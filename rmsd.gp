#!/usr/local/bin/gnuplot

#set terminal postscript eps enhanced background rgb 'white' color size 16cm , 10cm  "Times" 20
set terminal postscript eps enhanced background rgb 'white' color size 10cm , 4cm  "Times" 20
set output "rmsd.eps"

set encoding iso_8859_1

set tics out

#set multiplot layout 2,1

set tics font "Times-Roman,20"
set xlabel font "Times-Roman,24"
set ylabel font "Times-Roman,24"
set label font "Times-Roman,24"
set key font "Times-Roman,20"

set xlabel "Time (ns)"
set ylabel "RMSD (\305)" offset +1,0 

xmin=0
xmax=1000
set xtics 0,100,1000
set xrange [xmin:xmax]

ymin=0.0
ymax=5.0
set ytics 0.0,1.0,6.0
set yrange [ymin:ymax]

plot "rmsd.xvg"  u ($1/1000):($2*10) w l lw 2 lc rgb "red" notitle

quit
