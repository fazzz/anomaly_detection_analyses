#!/bin/sh

opt=( dummy parafile )
nopt=${#opt[*]}
if [ $# -le `expr ${nopt} - 2` ]; then
    echo "USAGE: $0" ${opt[*]:1:${nopt}}
    echo $*
    exit
fi

num=1
while [ $num -le `expr ${nopt} - 1` ]; do
    eval ${opt[$num]}=$1
    shift 1
    num=`expr $num + 1`
done

source ${parafile}

n_s=${#sparsity[*]}

if [ ! -d ${fig} ]; then
    mkdir ${fig}
fi

cd ${fig}

for s in ${sparsity[*]}; do
    dists=$( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${s}_anomaly.txt | awk '$4>0.0' )
    n_d=${#dists[*]}

    n_x=`expr ${n_d} / 3`
    
    flag=`expr ${n_id} % 3`
    if [ ${flag} -gt 0 ]; then
	n_x=`expr ${n_x} + 1`
    fi
    
    size_x=`expr 7 \* ${n_x}`

    cat <<EOF > ts_anomaly_d_r-r_${s}.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size ${xcm}cm , 16cm  \
"Times" 20
set output "ts_d_r-r_${s}.eps"

set encoding iso_8859_1
set tics out
set size square
set multiplot layout 3,${n_x}

set tics   font "Times-Roman,20"
set x2label font "Times-Roman,24"
set ylabel font "Times-Roman,24"
set label  font "Times-Roman,24"
set key    font "Times-Roman,20"

set xlabel "Time"
EOF

    j=1
    for i in ${dists[*]}; do
	pairs=( $( head -${i} ${anomaly}/a_d_r-r_sp=${s}_anomaly_pairs.txt | tail -1 ) )

	cat <<EOF >> ts_anomaly_d_r-r_${s}.gp
set ylabel  "Distance ${pairs[1]}-${pairs[2]} \305" offset +1,0 

plot \
"${dist_A}" u 0:${i} w l lt 1 lw 1.0 lc rgb "red" notitle \
"${dist_B}" u 0:${i} w l lt 1 lw 1.0 lc rgb "red" notitle

EOF

	j=`expr ${j} + 1`
    done

	cat <<EOF >> ts_anomaly_d_r-r_${s}.gp
quit
EOF

	gnuplot ts_anomaly_d_r-r_${s}.gp

done
