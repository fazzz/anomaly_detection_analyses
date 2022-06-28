#!/bin/sh

sparsity=( 0.90 0.80 0.70 0.60 0.50 )

anomaly=anomaly_d_r-r_2
dist=dist_r-r_2

for r in ${sparsity[*]}; do
    nl=$( wc -l ${anomaly}/a_d_r-r_sp=${r}_ss_A.txt | awk '{print $1}' )
    nl=`expr ${nl} - 1`

    for i in `seq 2 ${nl}`; do
	n1=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_A.txt | tail -1 | awk '{print $1}' )
	n2=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_A.txt | tail -1 | awk '{print $2}' )

	pair01=$( head -${n1} ${dist}/r-r_pairs_union-open-close.txt | tail -1 )
	pair02=$( head -${n2} ${dist}/r-r_pairs_union-open-close.txt | tail -1 )

	echo ${pair01[*]} "  " ${pair02[*]}
    done > ${anomaly}/a_d_r-r_sp=${r}_ss_A_res-res_pairs.txt

    for i in `seq 2 ${nl}`; do
	n1=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_A.txt | tail -1 | awk '{print $1}' )
	n2=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_A.txt | tail -1 | awk '{print $2}' )

	pair01=$( head -${n1} ${dist}/r-r_pairs_union-open-close.txt | tail -1 )
	pair02=$( head -${n2} ${dist}/r-r_pairs_union-open-close.txt | tail -1 )

	echo "draw_line_between_ca_ca " ${pair01[*]} " 0.3"
	echo "draw_line_between_ca_ca " ${pair02[*]} " 0.3"
    done > ${anomaly}/draw_line_between_ca_ca_open_sp=${r}

    nl=$( wc -l ${anomaly}/a_d_r-r_sp=${r}_ss_B.txt | awk '{print $1}' )
    nl=`expr ${nl} - 1`

    for i in `seq 2 ${nl}`; do
	n1=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_B.txt | tail -1 | awk '{print $1}' )
	n2=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_B.txt | tail -1 | awk '{print $2}' )

	pair01=$( head -${n1} ${dist}/r-r_pairs_union-open-close.txt | tail -1 )
	pair02=$( head -${n2} ${dist}/r-r_pairs_union-open-close.txt | tail -1 )
    
	echo ${pair01[*]} "  " ${pair02[*]}
    done  > ${anomaly}/a_d_r-r_sp=${r}_ss_B_res-res_pairs.txt

    for i in `seq 2 ${nl}`; do
	n1=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_B.txt | tail -1 | awk '{print $1}' )
	n2=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_B.txt | tail -1 | awk '{print $2}' )

	pair01=$( head -${n1} ${dist}/r-r_pairs_union-open-close.txt | tail -1 )
	pair02=$( head -${n2} ${dist}/r-r_pairs_union-open-close.txt | tail -1 )
    
	echo "draw_line_between_ca_ca " ${pair01[*]} " 0.2"
	echo "draw_line_between_ca_ca " ${pair02[*]} " 0.2"
    done > ${anomaly}/draw_line_between_ca_ca_close_sp=${r}

done
