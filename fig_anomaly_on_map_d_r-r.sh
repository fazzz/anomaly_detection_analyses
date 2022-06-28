#!/bin/sh

sparsity=( 0.90 0.80 0.70 0.60 0.50 )

if [ ! -d fig_d_r-r ]; then
    mkdir fig_d_r-r
fi

cd fig_d_r-r

for s in ${sparsity[*]}; do
    cat <<EOF > anomaly_on_map_d_r-r_sp=${s}.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 10cm , 10cm  "Times" 20
set output "anomaly_on_map_d_r-r_sp=${s}.eps"

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
set ytics 10,20,160
set yrange [ymin:ymax]
set mytics 1

f(x) = x

plot \\
     "../anomaly_d_r-r/a_d_r-r_sp=${s}_anomaly_top10_pairs.txt" u 1:2 w p pt 7 ps 2.0 lc rgb "black" notitle, \\
     "../anomaly_d_r-r/a_d_r-r_sp=${s}_anomaly_top11-20_pairs.txt" u 1:2 w p pt 7 ps 1.5 lc rgb "black" notitle, \\
     "../anomaly_d_r-r/a_d_r-r_sp=${s}_anomaly_top21-30_pairs.txt" u 1:2 w p pt 7 ps 1.0 lc rgb "black" notitle, \\
     "../anomaly_d_r-r/a_d_r-r_sp=${s}_anomaly_top31-40_pairs.txt" u 1:2 w p pt 7 ps 0.5 lc rgb "black" notitle, \\
     f(x) lw 2.0 lc rgb "black" w l notitle

EOF
    gnuplot anomaly_on_map_d_r-r_sp=${s}.gp
done
