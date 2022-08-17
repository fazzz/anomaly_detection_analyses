#!/bin/sh

opt=( dummy parafilename )
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

source ${parafilename}

n_s=${#sparsity[*]}

if [ ! -d ${fig} ]; then
    mkdir ${fig}
fi

cd ${fig}

cat <<EOF > anomaly_on_map_d_r-r.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 10cm , 10cm  "Times" 20
set output "anomaly_on_map_d_r-r.eps"

set encoding iso_8859_1

set tics out

set size square

set tics   font "Times-Roman,20"
set x2label font "Times-Roman,24"
set ylabel font "Times-Roman,24"
set label  font "Times-Roman,24"
set key    font "Times-Roman,20"

set style fill transparent solid 0.35 noborder
set style circle radius 1.0 #2.0

set key right bottom

set noxtics
set ytics
set x2tics
set ytics nomirror

set border 6

set x2label "Index of Residue"
set ylabel  "Index of Residue" offset +1,0 

set xrange [${min}:${max}]

set x2tics ${tics_min},${tics},${tics_max}
set x2range [${min}:${max}]

set ytics ${tics_min},${tics},${tics_max}
set yrange [${min}:${max}]

f(x) = x

plot \\
EOF

i=1
ps=4.0
for s in ${sparsity[*]}; do
    cat <<EOF >> anomaly_on_map_d_r-r.gp
"../${anomaly}/a_d_r-r_sp=${s}_anomaly_pairs.txt" u 1:2:(${ps}) w circles \
   lc "black" fs solid ${i}/${n_s}.0 title "{/Symbol r}=${s}", \\
EOF
i=`expr ${i} + 1`
ps=`echo "scale=4;${ps} * 0.8" | bc`
done

cat <<EOF >> anomaly_on_map_d_r-r.gp
f(x) lw 3.0 lc rgb "black" w l notitle
quit
EOF

gnuplot anomaly_on_map_d_r-r.gp
