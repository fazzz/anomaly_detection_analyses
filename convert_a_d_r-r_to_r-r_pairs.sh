#!/bin/sh

nl=$( wc -l anomaly_d_r-r/a_d_r-r_sp=0.80_ss_A.txt | awk '{print $1}' )
nl=`expr ${nl} - 1`

for i in `seq 2 ${nl}`; do
    n1=$( head -${i} anomaly_d_r-r/a_d_r-r_sp=0.80_ss_A.txt | tail -1 | awk '{print $1}' )
    n2=$( head -${i} anomaly_d_r-r/a_d_r-r_sp=0.80_ss_A.txt | tail -1 | awk '{print $2}' )

    pair01=$( head -${n1} dist_r-r/r-r_pairs_union-open-close.txt | tail -1 )
    pair02=$( head -${n2} dist_r-r/r-r_pairs_union-open-close.txt | tail -1 )

    echo ${pair01[*]} "  " ${pair02[*]}
done > anomaly_d_r-r/a_d_r-r_sp=0.80_ss_A_res-res_pairs.txt

nl=$( wc -l anomaly_d_r-r/a_d_r-r_sp=0.80_ss_B.txt | awk '{print $1}' )
nl=`expr ${nl} - 1`

for i in `seq 2 ${nl}`; do
    n1=$( head -${i} anomaly_d_r-r/a_d_r-r_sp=0.80_ss_B.txt | tail -1 | awk '{print $1}' )
    n2=$( head -${i} anomaly_d_r-r/a_d_r-r_sp=0.80_ss_B.txt | tail -1 | awk '{print $2}' )

    pair01=$( head -${n1} dist_r-r/r-r_pairs_union-open-close.txt | tail -1 )
    pair02=$( head -${n2} dist_r-r/r-r_pairs_union-open-close.txt | tail -1 )

    echo ${pair01[*]} "  " ${pair02[*]}
done  > anomaly_d_r-r/a_d_r-r_sp=0.80_ss_B_res-res_pairs.txt
