#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 10cm , 4cm  "Times" 12
set output "histgram_a_d_r-r_sparsity-effect.eps"

set encoding iso_8859_1

set tics out

set style fill solid border lc rgb "black"

set tics font "Times-Roman,12"
set xlabel font "Times-Roman,12"
set ylabel font "Times-Roman,12"
set label font "Times-Roman,12"
set key font "Times-Roman,12"

set boxwidth 0.04

set xlabel "Sparsity"
set ylabel "Num of non-zero elements" offset +1,0 

xmin=0.2
xmax=1.0
set xtics 0.3,0.1,0.9
set xrange [xmin:xmax]

plot "num_of_non-zero-elements_a_d_r-r_A.txt" u ($2-0.02):1 w boxes lw 2 lc rgb "pink" notitle, \
     "num_of_non-zero-elements_a_d_r-r_B.txt" u ($2+0.02):1 w boxes lw 2 lc rgb "light-blue" notitle

quit
