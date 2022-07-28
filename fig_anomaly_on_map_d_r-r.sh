#!/bin/sh

#sparsity=( 0.90 0.80 0.70 0.60 0.50 )
sparsity=( 0.50 0.60 0.70 0.80 0.90 )
n_s=${#sparsity[*]}

if [ ! -d fig_d_r-r ]; then
    mkdir fig_d_r-r
fi

cd fig_d_r-r

cat <<EOF > anomaly_on_map_d_r-r.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size 10cm , 10cm  "Times" 20
set output "anomaly_on_map_d_r-r.eps"

set encoding iso_8859_1

set tics out

set grid

set size square

set tics   font "Times-Roman,20"
set xlabel font "Times-Roman,24"
set ylabel font "Times-Roman,24"
set label  font "Times-Roman,24"
set key    font "Times-Roman,20"

#set palette model RGB functions gray ,0,0
#set palette model RGB rgbformulae 35,13,10
set key right bottom

#set rmargin 20
#unset colorbox

set style fill transparent solid 0.35 noborder
set style circle radius 2.0

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

i=1
ps=4.0
for s in ${sparsity[*]}; do
    cat <<EOF >> anomaly_on_map_d_r-r.gp
"../anomaly_d_r-r/a_d_r-r_sp=${s}_anomaly_pairs.txt" u 1:2:(${ps}) w circles lc "red" fs solid ${i}/${n_s}.0 title "{/Symbol r}=${s}", \\
EOF
i=`expr ${i} + 1`
ps=`echo "scale=4;${ps} * 0.8" | bc`
done

#i=0
#for s in ${sparsity[*]}; do
#    cat <<EOF >> anomaly_on_map_d_r-r.gp
#"../anomaly_d_r-r/a_d_r-r_sp=${s}_anomaly_top11-20_pairs.txt" u 1:2 w p pt 7 ps ${ps} lc palette frac ${i}/${n_s}.0 notitle, \\
#EOF
#i=`expr ${i} + 1`
#done

#i=0
#for s in ${sparsity[*]}; do
#    cat <<EOF >> anomaly_on_map_d_r-r.gp
#"../anomaly_d_r-r/a_d_r-r_sp=${s}_anomaly_top21-30_pairs.txt" u 1:2 w p pt 7 ps 1.0 lc palette frac ${i}/${n_s}.0 notitle, \\
#EOF
#i=`expr ${i} + 1`
#done

#i=0
#for s in ${sparsity[*]}; do
#    cat <<EOF >> anomaly_on_map_d_r-r.gp
#"../anomaly_d_r-r/a_d_r-r_sp=${s}_anomaly_top31-40_pairs.txt" u 1:2 w p pt 7 ps 0.5 lc palette frac ${i}/${n_s}.0 notitle, \\
#EOF
#i=`expr ${i} + 1`
#done

#i=0
#for s in ${sparsity[*]}; do
#    cat <<EOF >> anomaly_on_map_d_r-r.gp
#"../anomaly_d_r-r/a_d_r-r_sp=${s}_anomaly_top41-100_pairs.txt" u 1:2 w p pt 7 ps 0.1 lc palette frac ${i}/${n_s}.0 notitle, \\
#EOF
#i=`expr ${i} + 1`
#done

#i=0
#for s in ${sparsity[*]}; do
#    cat <<EOF >> anomaly_on_map_d_r-r.gp
#"../anomaly_d_r-r/a_d_r-r_sp=${s}_anomaly_top101_pairs.txt" u 1:2 w p pt 7 ps 0.1 lc palette frac ${i}/${n_s}.0 notitle, \\
#EOF
#i=`expr ${i} + 1`
#done

cat <<EOF >> anomaly_on_map_d_r-r.gp
f(x) lw 3.0 lc rgb "black" w l notitle
quit
EOF

gnuplot anomaly_on_map_d_r-r.gp
