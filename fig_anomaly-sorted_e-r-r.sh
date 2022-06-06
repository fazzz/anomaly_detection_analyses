#!/bin/sh

sparsity=( 0.70 0.60 0.50 0.40 0.30 )

cd anomaly_e_r-r

for s in ${sparsity[*]}; do
    sort -nrk 4,4 a_e_r-r_sp=${s}_anomaly.txt > a_e_r-r_sp=${s}_anomaly_sorted.txt
done

if [ ! -d fig_e_r-r ]; then
    mkdir fig_e_r-r
fi

cd ../fig_e_r-r

cat <<EOF > anomaly_sorted_a_e_r-r.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 16cm , 10cm  "Times" 20
set output "anomaly_sorted_a_e_r-r.eps"

set encoding iso_8859_1

set tics out
set multiplot

set lmargin 0
set rmargin 0
set tmargin 0
set bmargin 0

set style fill solid border lc rgb "black"

set tics font "Times-Roman,20"
set xlabel font "Times-Roman,24"
set ylabel font "Times-Roman,24"
set label font "Times-Roman,24"
set key font "Times-Roman,20"

set xlabel "#"
set ylabel "Anomaly" offset +1,0 

xmin=0
xmax=165
set xtics 10,20,160
set xrange [xmin:xmax]

set origin 0.12,0.12
set size   0.7,0.7

plot "../anomaly_e_r-r/a_e_r-r_sp=0.30_anomaly_sorted.txt" u 0:4 w p pt 7 ps 0.5 lc rgb "red" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.30_anomaly_sorted.txt" u 0:4 w l lc rgb "red" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.40_anomaly_sorted.txt" u 0:4 w p pt 7 ps 0.5 lc rgb "blue" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.40_anomaly_sorted.txt" u 0:4 w l lc rgb "blue" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.50_anomaly_sorted.txt" u 0:4 w p pt 7 ps 0.5 lc rgb "green" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.50_anomaly_sorted.txt" u 0:4 w l lc rgb "green" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.60_anomaly_sorted.txt" u 0:4 w p pt 7 ps 0.5 lc rgb "black" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.60_anomaly_sorted.txt" u 0:4 w l lc rgb "black" notitle

set noxlabel
set noylabel

xmin=0
xmax=40
set xtics 5,5,40
set xrange [xmin:xmax]

ymin=0
ymax=0.03
set ytics 0,0.01,0.03
set yrange [ymin:ymax]

set origin 0.4,0.4
set size   0.35,0.35

plot "../anomaly_e_r-r/a_e_r-r_sp=0.30_anomaly_sorted.txt" u 0:4 w p pt 7 ps 0.5 lc rgb "red" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.30_anomaly_sorted.txt" u 0:4 w l lc rgb "red" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.40_anomaly_sorted.txt" u 0:4 w p pt 7 ps 0.5 lc rgb "blue" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.40_anomaly_sorted.txt" u 0:4 w l lc rgb "blue" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.50_anomaly_sorted.txt" u 0:4 w p pt 7 ps 0.5 lc rgb "green" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.50_anomaly_sorted.txt" u 0:4 w l lc rgb "green" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.60_anomaly_sorted.txt" u 0:4 w p pt 7 ps 0.5 lc rgb "black" notitle,\
     "../anomaly_e_r-r/a_e_r-r_sp=0.60_anomaly_sorted.txt" u 0:4 w l lc rgb "black" notitle

quit
EOF

gnuplot anomaly_sorted_a_e_r-r.gp
