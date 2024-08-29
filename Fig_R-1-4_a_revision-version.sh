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

n_s=${#sparsity_riv[*]}

fig=${fig}_rivise-version

if [ ! -d ${fig} ]; then
    mkdir ${fig}
fi

cd ${fig}

cat <<EOF > Fig_R-1-4_a_revision-version.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 7cm , 7cm  "Times" 16
set output "Fig_R-1-4_a_revision-version.eps"

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
g(x) = x -1000

EOF

idx=1
for s in ${sparsity_riv[*]}; do
    cat <<EOF >> Fig_R-1-4_a_revision-version.gp
fnames_A_${idx}=system("/bin/ls tmp_${s}_A_*")
fnames_B_${idx}=system("/bin/ls tmp_${s}_B_*")
EOF
    idx=`expr ${idx} + 1`
done

cat <<EOF >> Fig_R-1-4_a_revision-version.gp
plot \\
EOF

idx=1
for s in ${sparsity_riv[*]}; do
    i=0;
    cat ../${anomaly}/a_d_r-r_sp=${s}_ss_A_res-res_pairs.txt | while read line; do
	echo $line | awk '{printf("%4d%4d\n%4d%4d\n", $1,$2,$3,$4)}' > tmp_${s}_A_${i};
	i=`expr ${i} + 1`;
    done

    cat <<EOF >> Fig_R-1-4_a_revision-version.gp
for [fn in fnames_A_${idx}] sprintf("%s",fn) u 1:2 w p pt 7 ps 0.4 lc rgb "red" notitle, \
for [fn in fnames_A_${idx}] sprintf("%s",fn) u 1:2 w l ${linetype_A[$idx]} lc rgb "red" notitle, \\
g(x) w l ${linetype_A[$idx]} lc rgb "red" title "{/Symbol r}=${s}(Open)", \\
EOF
    idx=`expr ${idx} + 1`
done

idx=1
for s in ${sparsity_riv[*]}; do
    i=0;
    cat ../${anomaly}/a_d_r-r_sp=${s}_ss_B_res-res_pairs.txt | while read line; do
	echo $line | awk '{printf("%4d%4d\n%4d%4d\n", $1,$2,$3,$4)}' > tmp_${s}_B_${i};
	i=`expr ${i} + 1`;
    done

    cat <<EOF >> Fig_R-1-4_a_revision-version.gp
for [fn in fnames_B_${idx}] sprintf("%s",fn) u 1:2 w p pt 7 ps 0.4 lc rgb "blue" notitle, \
for [fn in fnames_B_${idx}] sprintf("%s",fn) u 1:2 w l ${linetype_B[$idx]} lc rgb "blue" notitle, \\
g(x) w l ${linetype_B[$idx]} lc rgb "blue" title "{/Symbol r}=${s}(Closed)", \\
EOF
    idx=`expr ${idx} + 1`
done

cat <<EOF >> Fig_R-1-4_a_revision-version.gp
f(x) lw 3.0 lc rgb "black" w l notitle
quit
EOF

gnuplot Fig_R-1-4_a_revision-version.gp
