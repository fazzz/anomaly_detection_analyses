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

fig=${fig}_rivise-version

if [ ! -d ${fig} ]; then
    mkdir ${fig}
fi

cd ${fig}

cat <<EOF > Fig_1_b_revision-version.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 7cm , 7cm  "Times" 16
set output "Fig_1_b_revision-version.eps"

set encoding iso_8859_1

set tics out

set size square

set tics   font "Times-Roman,16"
set x2label font "Times-Roman,20"
set ylabel font "Times-Roman,20"
set label  font "Times-Roman,20"
set key    font "Times-Roman,16"

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
    cat <<EOF >> Fig_1_b_revision-version.gp
"../${anomaly}/a_d_r-r_sp=${s}_anomaly_pairs.txt" u 1:2:(${ps}) w circles \
   lc "black" fs solid ${i}/${n_s}.0 title "{/Symbol r}=${s}", \\
EOF
i=`expr ${i} + 1`
ps=`echo "scale=4;${ps} * 0.8" | bc`
done

cat <<EOF >> Fig_1_b_revision-version.gp
f(x) lw 3.0 lc rgb "black" w l notitle
quit
EOF

gnuplot Fig_1_b_revision-version.gp
