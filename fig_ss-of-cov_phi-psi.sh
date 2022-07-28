#!/bin/sh

#sparsity=( 0.90 0.80 0.70 0.60 0.50 )
sparsity=( 0.40 0.30 0.20 )

if [ ! -d fig_phi-psi ]; then
    mkdir fig_phi-psi
fi

cd fig_phi-psi

for s in ${sparsity[*]}; do
    cat <<EOF > ss-of-cov_phi_psi_sp=${s}.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 14cm , 14cm  "Times" 20
set output "ss-of-cov_phi_psi_sp=${s}.eps"

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
xmax=656
set xtics 0,164,656

set xtics add ("50" 50, "100" 100, "50" 214, "100" 264, "164" 328, "50" 378, "100" 428, "164" 492, "50" 542, "100" 592, "164" 656)

set xrange [xmin:xmax]
set mxtics 1

ymin=1
ymax=656
set ytics 0,164,656

set ytics add ("50" 50, "100" 100, "50" 214, "100" 264, "164" 328, "50" 378, "100" 428, "164" 492, "50" 542, "100" 592, "164" 656)

set yrange [ymin:ymax]
set mytics 1

f(x) = x

plot "../anomaly_phi_psi/a_phi_psi_sp=${s}_ss_A_r-r_idx.txt" u 1:2 w p pt 7 ps 1.0 lc rgb "red"   notitle, \
     "../anomaly_phi_psi/a_phi_psi_sp=${s}_ss_B_r-r_idx.txt" u 2:1 w p pt 7 ps 1.0 lc rgb "black" notitle, \
     f(x) lw 2.0 lc rgb "black" w l notitle

quit
EOF

    gnuplot ss-of-cov_phi_psi_sp=${s}.gp
done
