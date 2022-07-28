#!/bin/sh

sparsity=( 0.90 0.80 0.70 0.60 0.50 )
n_s=${#sparsity[*]}

if [ ! -d fig_phi-psi ]; then
    mkdir fig_phi-psi
fi

cd fig_phi-psi

for s in ${sparsity[*]}; do

    n=$( wc -l ../anomaly_phi_psi/a_phi_psi_sp=${s}_anomaly.txt | awk '{print $1}' )
    n=`expr ${n} - 2`

    tail -${n} ../anomaly_phi_psi/a_phi_psi_sp=${s}_anomaly.txt > tmp01
    awk '{printf("%s %s %4d\n",$1,$2,$3)}' ../phi-psi/phi-psi_index.txt > tmp02

    paste tmp02 tmp01 > tmp03

    grep "sin phi" tmp03 > ../anomaly_phi_psi/a_phi_psi_sp=${s}_anomaly_sinphi.txt
    grep "cos phi" tmp03 > ../anomaly_phi_psi/a_phi_psi_sp=${s}_anomaly_cosphi.txt

    grep "sin psi" tmp03 > ../anomaly_phi_psi/a_phi_psi_sp=${s}_anomaly_sinpsi.txt
    grep "cos psi" tmp03 > ../anomaly_phi_psi/a_phi_psi_sp=${s}_anomaly_cospsi.txt

    cat <<EOF > histgram_a_phi_psi_sp=${s}.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 22cm , 10cm  "Times" 10
set output "histgram_phi-psi_${s}.eps"

set encoding iso_8859_1

set tics out

set multiplot layout 2,1

set style fill solid border lc rgb "black"

set tics font "Times-Roman,10"
set xlabel font "Times-Roman,24"
set ylabel font "Times-Roman,24"
set label font "Times-Roman,24"
set key font "Times-Roman,20"

set boxwidth 0.5

set xlabel "Index of Residue"
set ylabel "Anomaly" offset +1,0 

xmin=0
xmax=164
set xtics 10,10,160
set xrange [xmin:xmax]

plot "../anomaly_phi_psi/a_phi_psi_sp=${s}_anomaly_sinphi.txt" u (\$3-0.25):5 w boxes lw 2 lc rgb "light-blue" notitle, \
     "../anomaly_phi_psi/a_phi_psi_sp=${s}_anomaly_cosphi.txt" u (\$3+0.25):5 w boxes lw 2 lc rgb "light-pink" notitle

plot "../anomaly_phi_psi/a_phi_psi_sp=${s}_anomaly_sinpsi.txt" u (\$3-0.25):5 w boxes lw 2 lc rgb "light-blue" notitle, \
     "../anomaly_phi_psi/a_phi_psi_sp=${s}_anomaly_cospsi.txt" u (\$3+0.25):5 w boxes lw 2 lc rgb "light-pink" notitle

quit
EOF

    gnuplot histgram_a_phi_psi_sp=${s}.gp
done

