#!/bin/sh

#sparsity=( 0.90 0.80 0.70 0.60 0.50 )
sparsity=( 0.40 0.30 0.20 )

anomaly=anomaly_phi_psi

for r in ${sparsity[*]}; do
    nl=$( wc -l ${anomaly}/a_phi_psi_sp=${r}_ss_A.txt | awk '{print $1}' )
    nl=`expr ${nl} - 1`

    for i in `seq 2 ${nl}`; do
	n1=$( head -${i} ${anomaly}/a_phi_psi_sp=${r}_ss_A.txt | tail -1 | awk '{print $1}' )
	n2=$( head -${i} ${anomaly}/a_phi_psi_sp=${r}_ss_A.txt | tail -1 | awk '{print $2}' )

	pair01=$( head -${n1} phi-psi/phi-psi_index.txt | tail -1 )
	pair02=$( head -${n2} phi-psi/phi-psi_index.txt | tail -1 )

	echo ${pair01[*]} "  " ${pair02[*]} | awk '$1~/cos/ && $2~/phi/{$3=$3+164}$4~/cos/ && $5~/phi/{$6=$6+164}$1~/sin/ && $2~/psi/{$3=$3+164*2}$4~/sin/ && $5~/psi/{$6=$6+164*2}$1~/cos/ && $2~/psi/{$3=$3+164*3}$4~/cos/ && $5~/psi/{$6=$6+164*3}$3<$6{print $3 " " $6}$6<$3{print $6 " " $3}'
    done > ${anomaly}/a_phi_psi_sp=${r}_ss_A_r-r_idx.txt

    nl=$( wc -l ${anomaly}/a_phi_psi_sp=${r}_ss_B.txt | awk '{print $1}' )
    nl=`expr ${nl} - 1`

    for i in `seq 2 ${nl}`; do
	n1=$( head -${i} ${anomaly}/a_phi_psi_sp=${r}_ss_B.txt | tail -1 | awk '{print $1}' )
	n2=$( head -${i} ${anomaly}/a_phi_psi_sp=${r}_ss_B.txt | tail -1 | awk '{print $2}' )

	pair01=$( head -${n1} phi-psi/phi-psi_index.txt | tail -1 )
	pair02=$( head -${n2} phi-psi/phi-psi_index.txt | tail -1 )

	echo ${pair01[*]} "  " ${pair02[*]} | awk '$1~/cos/ && $2~/phi/{$3=$3+164}$4~/cos/ && $5~/phi/{$6=$6+164}$1~/sin/ && $2~/psi/{$3=$3+164*2}$4~/sin/ && $5~/psi/{$6=$6+164*2}$1~/cos/ && $2~/psi/{$3=$3+164*3}$4~/cos/ && $5~/psi/{$6=$6+164*3}$3<$6{print $3 " " $6}$6<$3{print $6 " " $3}'
    done > ${anomaly}/a_phi_psi_sp=${r}_ss_B_r-r_idx.txt
done
