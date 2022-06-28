#!/bin/sh

sparsity=( 0.90 0.80 0.70 0.60 0.50 )

if [ ! -d fig_d_r-r_2 ]; then
    mkdir fig_d_r-r_2
fi

cd fig_d_r-r_2

for s in ${sparsity[*]}; do
    mkdir tmp

    if [ -f tmp01 ]; then
	rm tmp01
    fi

    if [ -f tmp02 ]; then
	rm tmp02
    fi

    i=1
    cat ../anomaly_d_r-r_2/a_d_r-r_sp=${s}_ss_A_res-res_pairs.txt | while read line; do
	echo ${line} | awk '{printf("%4d %4d\n%4d %4d\n", $1, $2, $3, $4)}' > tmp/${i}_A

	cat <<EOF >> tmp01
"tmp/${i}_A" u 1:2 w p pt   7 ps 1.0 lc rgb "red"   notitle, \\
"tmp/${i}_A" u 1:2 w l lw 0.5 lc rgb "red"   notitle, \\
EOF
	i=`expr ${i} + 1`
    done

    i=1
    cat ../anomaly_d_r-r_2/a_d_r-r_sp=${s}_ss_B_res-res_pairs.txt | while read line; do
	echo ${line} | awk '{printf("%4d %4d\n%4d %4d\n", $1, $2, $3, $4)}' > tmp/${i}_B

	cat <<EOF >> tmp02
"tmp/${i}_B" u 2:1 w p pt   7 ps 1.0 lc rgb "blue"   notitle, \\
"tmp/${i}_B" u 2:1 w l lw 0.5 lc rgb "blue"   notitle, \\
EOF
	i=`expr ${i} + 1`
    done

    cat <<EOF > ss-of-cov_d_r-r_2_sp=${s}.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 10cm , 10cm  "Times" 20
set output "ss-of-cov_d_r-r_2_sp=${s}.eps"

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
EOF

    cat tmp01 >> ss-of-cov_d_r-r_2_sp=${s}.gp
    cat tmp02 >> ss-of-cov_d_r-r_2_sp=${s}.gp

    cat <<EOF >> ss-of-cov_d_r-r_2_sp=${s}.gp
     f(x) lw 2.0 lc rgb "black" w l notitle

quit
EOF
    gnuplot ss-of-cov_d_r-r_2_sp=${s}.gp

    rm -r tmp
    rm tmp01
    rm tmp02

done
