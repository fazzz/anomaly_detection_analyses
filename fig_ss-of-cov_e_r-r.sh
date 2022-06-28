#!/bin/sh

sparsity=( 0.90 0.80 0.70 0.60 0.50 0.40 0.30 )

if [ ! -d fig_e_r-r ]; then
    mkdir fig_e_r-r
fi

cd fig_e_r-r

for s in ${sparsity[*]}; do
    cat <<EOF > ss-of-cov_e_r-r_sp=${s}.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 10cm , 10cm  "Times" 20
set output "ss-of-cov_e_r-r_sp=${s}.eps"

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

plot "../anomaly_e_r-r/a_e_r-r_sp=${s}_ss_A.txt" u 1:2 w p pt  7 ps 2.0 lc rgb "red"   notitle, \
     "../anomaly_e_r-r/a_e_r-r_sp=${s}_ss_B.txt" u 1:2 w p pt 13 ps 1.6 lc rgb "black" notitle, \
     f(x) lw 2.0 lc rgb "black" w l notitle

quit
EOF

    gnuplot ss-of-cov_e_r-r_sp=${s}.gp
done

cat <<EOF > ss-of-cov_e_r-r.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 20cm , 20cm  "Times" 20
set output "ss-of-cov_e_r-r.eps"

set encoding iso_8859_1

set tics out
set multiplot

set lmargin 0
set rmargin 0
set tmargin 0
set bmargin 0

set grid

set size square

set tics   font "Times-Roman,20"
set xlabel font "Times-Roman,24"
set ylabel font "Times-Roman,24"
set label  font "Times-Roman,24"
set key    font "Times-Roman,20"

#set xlabel "Index of Residue"
#set ylabel "Index of Residue" offset +1,0 

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

set noxlabel
set noylabel

f(x) = x

set origin 0.10,0.45
set size   0.29,0.29

set label 1 at graph 0.5, 0.1 "Sparsity = 0.30"
set label 2 center at screen 0.05,0.595 "Index of Residue" rotate by 90.0

plot "../anomaly_e_r-r/a_e_r-r_sp=0.30_ss_A.txt" u 1:2 w p pt  7 ps 2.0 lc rgb "red"   notitle, \
     "../anomaly_e_r-r/a_e_r-r_sp=0.30_ss_B.txt" u 1:2 w p pt 13 ps 1.6 lc rgb "black" notitle, \
     f(x) lw 2.0 lc rgb "black" w l notitle

set origin 0.45,0.45
set size   0.29,0.29

set label 1 at graph 0.5, 0.1 "Sparsity = 0.40"

plot "../anomaly_e_r-r/a_e_r-r_sp=0.40_ss_A.txt" u 1:2 w p pt  7 ps 2.0 lc rgb "red"   notitle, \
     "../anomaly_e_r-r/a_e_r-r_sp=0.40_ss_B.txt" u 1:2 w p pt 13 ps 1.6 lc rgb "black" notitle, \
     f(x) lw 2.0 lc rgb "black" w l notitle

set origin 0.10,0.10
set size   0.29,0.29

set label 1 at graph 0.5, 0.1 "Sparsity = 0.50"
set label 3 center at screen 0.245,0.05 "Index of Residue"
set label 4 center at screen 0.05,0.245 "Index of Residue" rotate by 90.0

plot "../anomaly_e_r-r/a_e_r-r_sp=0.50_ss_A.txt" u 1:2 w p pt  7 ps 2.0 lc rgb "red"   notitle, \
     "../anomaly_e_r-r/a_e_r-r_sp=0.50_ss_B.txt" u 1:2 w p pt 13 ps 1.6 lc rgb "black" notitle, \
     f(x) lw 2.0 lc rgb "black" w l notitle

set origin 0.45,0.10
set size   0.29,0.29

set label 1 at graph 0.5, 0.1 "Sparsity = 0.60"
set label 5 center at screen 0.595,0.05 "Index of Residue"

plot "../anomaly_e_r-r/a_e_r-r_sp=0.60_ss_A.txt" u 1:2 w p pt  7 ps 2.0 lc rgb "red"   notitle, \
     "../anomaly_e_r-r/a_e_r-r_sp=0.60_ss_B.txt" u 1:2 w p pt 13 ps 1.6 lc rgb "black" notitle, \
     f(x) lw 2.0 lc rgb "black" w l notitle

quit
EOF

gnuplot ss-of-cov_e_r-r.gp
