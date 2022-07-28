#!/bin/sh

sparsity=( 0.90 0.80 0.70 0.60 0.50 0.40 )

anomaly=anomaly_d_r-r_2
dist=dist_r-r_2

for r in ${sparsity[*]}; do
    pair_top10=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | head -10 | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
    n_pair_top10=${#pair_top10[*]}

    if [ ${n_pair_top10} -gt 0 ]; then
	for i in ${pair_top10[*]}; do
	    head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1
	done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top10_pairs.txt
    fi

    pair_top20=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | head -20 | tail -10 | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
    n_pair_top20=${#pair_top20[*]}

    if [ ${n_pair_top20} -gt 0 ]; then
	for i in ${pair_top20[*]}; do
	    head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1
	done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top11-20_pairs.txt
    fi

    pair_top30=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | head -30 | tail -10 | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
    n_pair_top30=${#pair_top30[*]}

    if [ ${n_pair_top30} -gt 0 ]; then
	for i in ${pair_top30[*]}; do
	    head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1
	done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top21-30_pairs.txt
    fi

    pair_top40=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | head -40 | tail -10 | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
    n_pair_top40=${#pair_top40[*]}

    if [ ${n_pair_top40} -gt 0 ]; then
	for i in ${pair_top40[*]}; do
	    head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1
	done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top31-40_pairs.txt
    fi

    pair_top100=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | head -100 | tail -60 | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
    n_pair_top100=${#pair_top100[*]}

    if [ ${n_pair_top100} -gt 0 ]; then
	for i in ${pair_top100[*]}; do
	    head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1
	done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top41-100_pairs.txt
    fi

done
