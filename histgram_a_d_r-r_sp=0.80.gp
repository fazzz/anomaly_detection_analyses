#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 12cm , 4cm  "Times" 12
set output "histgram_a_d_r-r_sp=0.80.eps"

set encoding iso_8859_1

set tics out

set style fill solid border lc rgb "black"

set tics font "Times-Roman,12"
set xlabel font "Times-Roman,12"
set ylabel font "Times-Roman,12"
set label font "Times-Roman,12"
set key font "Times-Roman,12"

set xlabel "Index of Residue"
set ylabel "Anomaly" offset +1,0 

xmin=0
xmax=290
set xtics 10,10,280
set xrange [xmin:xmax]

plot "anomaly_d_r-r/a_d_r-r_sp=0.80_anomaly.txt" u 1:2 w boxes lw 2 lc rgb "light-blue" notitle

quit
