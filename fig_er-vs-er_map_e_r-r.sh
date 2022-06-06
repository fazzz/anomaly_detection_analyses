#!/bin/sh

opt=( dummy sparsity resid )
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

cd anomaly_e_r-r

awk 'BEGIN{print "A "}$1=='$resid'{print $2}$2=='$resid'{print $1}' \
    a_e_r-r_sp=${sparsity}_ss_A.txt | tr "\n" " " \
    > reslist_sp=${sparsity}_${resid}.txt
echo "\n" >> reslist_sp=${sparsity}_${resid}.txt

awk 'BEGIN{print "B "}$1=='$resid'{print $2}$2=='$resid'{print $1}' \
    a_e_r-r_sp=${sparsity}_ss_B.txt | tr "\n" " " \
    >> reslist_sp=${sparsity}_${resid}.txt
echo "\n" >> reslist_sp=${sparsity}_${resid}.txt

id_res_correrate_A=( $( head -1 reslist_sp=${sparsity}_${resid}.txt | awk '{for(i=2;i<NF;++i){print $i}}' ) )
id_res_correrate_B=( $( tail -1 reslist_sp=${sparsity}_${resid}.txt | awk '{for(i=2;i<NF;++i){print $i}}' ) )

n_id_res_correrate_A=${#id_res_correrate_A[*]}
n_id_res_correrate_B=${#id_res_correrate_B[*]}

cd ..

if [ ! -d fig_e_r-r ]; then
    mkdir fig_e_r-r
fi

cd fig_e_r-r

if [ ${n_id_res_correrate_A} -gt 0 ]; then
    n_id=`expr ${n_id_res_correrate_A}`
    n_x=`expr ${n_id} / 2`

    flag=`expr ${n_id} % 2`
    if [ ${flag} -gt 0 ]; then
	n_x=`expr ${n_x} + 1`
    fi

    size_x=`expr 9 \* ${n_x}`

    cat <<EOF > e_r-r_corr-map_${resid}res_vs_${n_id_res_correrate_A}ress_open.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size ${size_x}cm, 16cm  "Times" 20
set output "e_r-r_corr-map_${resid}res_vs_${n_id_res_correrate_A}ress_open.eps"

set encoding iso_8859_1
set tics out
set size square
set multiplot layout 2, ${n_x}

set style fill transparent solid 0.35 noborder

set tics   font "Times-Roman,16"
set xlabel font "Times-Roman,16"
set ylabel font "Times-Roman,16"
set label  font "Times-Roman,16"
set key    font "Times-Roman,16"

set xlabel "E@^{res}_{${resid}} (kJ/mol)"
EOF

    for i in ${id_res_correrate_A[*]}; do
	cat <<EOF >> e_r-r_corr-map_${resid}res_vs_${n_id_res_correrate_A}ress_open.gp
set ylabel "E@^{res}_{${i}} (kJ/mol)" offset +1,0 

plot "../eneres_scaled/ene_res.txt" u ${resid}:${i} pt 7 ps 1.2 lc rgb "red" notitle
EOF
    done

    cat <<EOF >> e_r-r_corr-map_${resid}res_vs_${n_id_res_correrate_A}ress_open.gp
quit
EOF

    gnuplot e_r-r_corr-map_${resid}res_vs_${n_id_res_correrate_A}ress_open.gp

    cat <<EOF > e_r-r_no-corr-map_${resid}res_vs_${n_id_res_correrate_A}ress_close.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size ${size_x}cm, 16cm  "Times" 20
set output "e_r-r_no-corr-map_${resid}res_vs_${n_id_res_correrate_A}ress_close.eps"

set encoding iso_8859_1
set tics out
set size square
set multiplot layout 2, ${n_x}

set style fill transparent solid 0.35 noborder

set tics   font "Times-Roman,16"
set xlabel font "Times-Roman,16"
set ylabel font "Times-Roman,16"
set label  font "Times-Roman,16"
set key    font "Times-Roman,16"

set xlabel "E@^{res}_{${resid}} (kJ/mol)"
EOF

    for i in ${id_res_correrate_A[*]}; do
	cat <<EOF >> e_r-r_no-corr-map_${resid}res_vs_${n_id_res_correrate_A}ress_close.gp
set ylabel "E@^{res}_{${i}} (kJ/mol)" offset +1,0 

plot "../../../close/analyses/eneres_scaled/ene_res.txt" u ${resid}:${i} w p pt 7 ps 2.0 lc rgb "black" notitle
EOF
    done

    cat <<EOF >> e_r-r_no-corr-map_${resid}res_vs_${n_id_res_correrate_A}ress_close.gp
quit
EOF

    gnuplot e_r-r_no-corr-map_${resid}res_vs_${n_id_res_correrate_A}ress_close.gp
fi

if [ ${n_id_res_correrate_B} -gt 0 ]; then
    n_id=`expr ${n_id_res_correrate_B}`
    n_x=`expr ${n_id} / 2`

    flag=`expr ${n_id} % 2`
    if [ ${flag} -gt 0 ]; then
	n_x=`expr ${n_x} + 1`
    fi

    size_x=`expr 9 \* ${n_x}`

    cat <<EOF > e_r-r_corr-map_${resid}res_vs_${n_id_res_correrate_B}ress_close.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size ${size_x}cm, 16cm  "Times" 20
set output "e_r-r_corr-map_${resid}res_vs_${n_id_res_correrate_B}ress_close.eps"

set encoding iso_8859_1
set tics out
set size square
set multiplot layout 2, ${n_x}

set tics   font "Times-Roman,16"
set xlabel font "Times-Roman,16"
set ylabel font "Times-Roman,16"
set label  font "Times-Roman,16"
set key    font "Times-Roman,16"

set xlabel "E@^{res}_{${resid}} (kJ/mol)"
EOF

    for i in ${id_res_correrate_B[*]}; do
	cat <<EOF >> e_r-r_corr-map_${resid}res_vs_${n_id_res_correrate_B}ress_close.gp
set ylabel "E@^{res}_{${i}} (kJ/mol)" offset +1,0 

plot "../../../close/analyses/eneres_scaled/ene_res.txt" u ${resid}:${i} w p pt 7 ps 2.0 lc rgb "black" notitle
EOF
    done

    cat <<EOF >> e_r-r_corr-map_${resid}res_vs_${n_id_res_correrate_B}ress_close.gp
quit
EOF

    gnuplot e_r-r_corr-map_${resid}res_vs_${n_id_res_correrate_B}ress_close.gp

    cat <<EOF > e_r-r_no-corr-map_${resid}res_vs_${n_id_res_correrate_B}ress_open.gp
#!/usr/local/bin/gnuplot

set terminal postscript eps enhanced background rgb 'white' color size ${size_x}cm, 16cm  "Times" 20
set output "e_r-r_no-corr-map_${resid}res_vs_${n_id_res_correrate_B}ress_open.eps"

set encoding iso_8859_1
set tics out
set size square
set multiplot layout 2, ${n_x}

set tics   font "Times-Roman,16"
set xlabel font "Times-Roman,16"
set ylabel font "Times-Roman,16"
set label  font "Times-Roman,16"
set key    font "Times-Roman,16"

set xlabel "E@^{res}_{${resid}} (kJ/mol)"
EOF

    for i in ${id_res_correrate_B[*]}; do
	cat <<EOF >> e_r-r_no-corr-map_${resid}res_vs_${n_id_res_correrate_B}ress_open.gp
set ylabel "E@^{res}_{${i}} (kJ/mol)" offset +1,0 

plot "../eneres_scaled/ene_res.txt" u ${resid}:${i} w p pt 7 ps 2.0 lc rgb "red" notitle

EOF
    done

    cat <<EOF >> e_r-r_no-corr-map_${resid}res_vs_${n_id_res_correrate_B}ress_open.gp
quit
EOF

    gnuplot e_r-r_no-corr-map_${resid}res_vs_${n_id_res_correrate_B}ress_open.gp
fi
