#!/bin/sh

sparsity=( 0.90 0.80 0.70 0.60 0.50 0.40 )

anomaly=anomaly_d_r-r
dist=dist_r-r

for r in ${sparsity[*]}; do

    num_anomaly=$( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | wc -l )

    pair_all=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
    n_pair_all=${#pair_all[*]}
	
    if [ ${n_pair_all} -gt 0 ]; then
	for i in ${pair_all[*]}; do
	    head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1
	done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_pairs.txt

	for i in ${pair_all[*]}; do
	    pair=$( head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1 )

	    echo "draw_line_between_ca_ca " ${pair[*]} " 0.3"

	done > ${anomaly}/draw_line_between_ca_ca_anomaly_sp=${r}
    fi

    pair_top10=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | head -10 | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
    n_pair_top10=${#pair_top10[*]}

    if [ ${n_pair_top10} -gt 0 ]; then
	for i in ${pair_top10[*]}; do
	    head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1
	done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top10_pairs.txt
    fi

    if [ ${num_anomaly} -gt 10 ]; then
	n=`expr ${num_anomaly} - 10`
	if [ ${n} -gt 10 ]; then
	    n=10
	fi

	pair_top20=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | head -20 | tail -${n} | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
	n_pair_top20=${#pair_top20[*]}
	
	if [ ${n_pair_top20} -gt 0 ]; then
	    for i in ${pair_top20[*]}; do
		head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1
	    done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top11-20_pairs.txt
	fi

	if [ ${num_anomaly} -gt 20 ]; then
	    n=`expr ${num_anomaly} - 20`
	    if [ ${n} -gt 10 ]; then
		n=10
	    fi

	    pair_top30=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | head -30 | tail -${n} | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
	    n_pair_top30=${#pair_top30[*]}
	    
	    if [ ${n_pair_top30} -gt 0 ]; then
		for i in ${pair_top30[*]}; do
		    head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1
		done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top21-30_pairs.txt
	    fi

	    if [ ${num_anomaly} -gt 30 ]; then
		n=`expr ${num_anomaly} - 30`
		if [ ${n} -gt 10 ]; then
		    n=10
		fi

		pair_top40=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | head -40 | tail -${n} | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
		n_pair_top40=${#pair_top40[*]}

		if [ ${n_pair_top40} -gt 0 ]; then
		    for i in ${pair_top40[*]}; do
			head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1
		    done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top31-40_pairs.txt
		fi

		if [ ${num_anomaly} -gt 40 ]; then
		    n=`expr ${num_anomaly} - 40`
		    if [ ${n} -gt 60 ]; then
			n=60
		    fi

		    pair_top100=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | head -100 | tail -${n} | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
		    n_pair_top100=${#pair_top100[*]}
		    
		    if [ ${n_pair_top100} -gt 0 ]; then
			for i in ${pair_top100[*]}; do
			    head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1
			done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top41-100_pairs.txt
		    fi

		    if [ ${num_anomaly} -gt 100 ]; then
			n=`expr ${num_anomaly} - 100`

			pair_top100=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | tail -${n} | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
			n_pair_top100=${#pair_top100[*]}
		    
			if [ ${n_pair_top100} -gt 0 ]; then
			    for i in ${pair_top100[*]}; do
				head -$i ${dist}/r-r_pairs_union-open-close.txt | tail -1
			    done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top101_pairs.txt
			fi
		    fi
		fi
	    fi
	fi
    fi
done
