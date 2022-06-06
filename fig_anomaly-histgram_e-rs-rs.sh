#!/bin/sh

sparsity=( 0.30 0.20 0.10 )
n_s=${#sparsity[*]}

if [ ! -d fig_e_rs-rs ]; then
    mkdir fig_e_rs-rs
fi

cd fig_e_rs-rs

for s in ${sparsity[*]}; do
    cat <<EOF > histgram_a_e_rs-rs_sp=${s}.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 20cm , 5cm  "Times" 20
set output "histgram_e_rs-rs_${s}.eps"

set encoding iso_8859_1

set tics out

set style fill solid border lc rgb "black"

set tics font "Times-Roman,20"
set xlabel font "Times-Roman,24"
set ylabel font "Times-Roman,24"
set label font "Times-Roman,24"
set key font "Times-Roman,20"

set xlabel "Index of Residue"
set ylabel "Anomaly" offset +1,0 

xmin=0
xmax=165
set xtics 10,20,160
set xrange [xmin:xmax]

plot "../anomaly_e_rs-rs/a_e_rs-rs_sp=${s}_anomaly.txt" u 1:2 w boxes lw 2 lc rgb "light-blue" notitle

quit
EOF

    gnuplot histgram_a_e_rs-rs_sp=${s}.gp
done

cat <<EOF > histgrams_a_e_rs-rs.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 20cm , 20cm "Times" 20
set output "histgrams_a_e_rs-rs.eps"

set encoding iso_8859_1

set tics out
set multiplot

set lmargin 0
set rmargin 0
set tmargin 0
set bmargin 0

set style fill solid border lc rgb "black"

unset key

set ylabel "Anomaly" offset +1,0 

xmin=0
xmax=165
set xtics 10,20,160
set xrange [xmin:xmax]

set origin 0.1,0.79
set size   0.8,0.19

set noxlabel
set label 1 at graph 0.5, 0.8 "Sparsity = 0.10"
plot "../anomaly_e_rs-rs/a_e_rs-rs_sp=0.10_anomaly.txt" u 1:2 w boxes lw 2 lc rgb "light-blue" notitle

set origin 0.1,0.55
set size   0.8,0.19

set label 1 at graph 0.5, 0.8 "Sparsity = 0.20"
plot "../anomaly_e_rs-rs/a_e_rs-rs_sp=0.20_anomaly.txt" u 1:2 w boxes lw 2 lc rgb "light-blue" notitle

set origin 0.1,0.31
set size   0.8,0.19

set label 1 at graph 0.5, 0.8 "Sparsity = 0.30"
plot "../anomaly_e_rs-rs/a_e_rs-rs_sp=0.30_anomaly.txt" u 1:2 w boxes lw 2 lc rgb "light-blue" notitle

quit
EOF

gnuplot histgrams_a_e_rs-rs.gp
