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

for r in ${sparsity[*]}; do
    nl=$( wc -l ${anomaly}/a_d_r-r_sp=${r}_ss_A.txt | awk '{print $1}' )
    nl=`expr ${nl} - 1`

    for i in `seq 2 ${nl}`; do
	n1=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_A.txt | tail -1 | awk '{print $1}' )
	n2=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_A.txt | tail -1 | awk '{print $2}' )

	pair01=$( head -${n1} ${dist}/${pairs} | tail -1 | awk '{printf("%d %d",$1+'$nc',$2+'$nc')}' )
	pair02=$( head -${n2} ${dist}/${pairs} | tail -1 | awk '{printf("%d %d",$1+'$nc',$2+'$nc')}' )

	echo ${pair01[*]} "  " ${pair02[*]}
    done > ${anomaly}/a_d_r-r_sp=${r}_ss_A_res-res_pairs.txt

    for i in `seq 2 ${nl}`; do
	n1=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_A.txt | tail -1 | awk '{print $1}' )
	n2=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_A.txt | tail -1 | awk '{print $2}' )

	pair01=$( head -${n1} ${dist}/${pairs} | tail -1 | awk '{printf("%d %d",$1+'$nc',$2+'$nc')}' )
	pair02=$( head -${n2} ${dist}/${pairs} | tail -1 | awk '{printf("%d %d",$1+'$nc',$2+'$nc')}' )

	echo "draw_line_between_ca_ca " ${pair01[*]} " 0.1"
	echo "draw_line_between_ca_ca " ${pair02[*]} " 0.1"
    done > ${anomaly}/draw_line_between_ca_ca_open_sp=${r}

    nl=$( wc -l ${anomaly}/a_d_r-r_sp=${r}_ss_B.txt | awk '{print $1}' )
    nl=`expr ${nl} - 1`

    for i in `seq 2 ${nl}`; do
	n1=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_B.txt | tail -1 | awk '{print $1}' )
	n2=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_B.txt | tail -1 | awk '{print $2}' )

	pair01=$( head -${n1} ${dist}/${pairs} | tail -1 | awk '{printf("%d %d",$1+'$nc',$2+'$nc')}' )
	pair02=$( head -${n2} ${dist}/${pairs} | tail -1 | awk '{printf("%d %d",$1+'$nc',$2+'$nc')}' )
    
	echo ${pair01[*]} "  " ${pair02[*]}
    done  > ${anomaly}/a_d_r-r_sp=${r}_ss_B_res-res_pairs.txt

    for i in `seq 2 ${nl}`; do
	n1=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_B.txt | tail -1 | awk '{print $1}' )
	n2=$( head -${i} ${anomaly}/a_d_r-r_sp=${r}_ss_B.txt | tail -1 | awk '{print $2}' )

	pair01=$( head -${n1} ${dist}/${pairs} | tail -1 | awk '{printf("%d %d",$1+'$nc',$2+'$nc')}' )
	pair02=$( head -${n2} ${dist}/${pairs} | tail -1 | awk '{printf("%d %d",$1+'$nc',$2+'$nc')}' )
    
	echo "draw_line_between_ca_ca " ${pair01[*]} " 0.1"
	echo "draw_line_between_ca_ca " ${pair02[*]} " 0.1"
    done > ${anomaly}/draw_line_between_ca_ca_close_sp=${r}


    num_anomaly=$( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | wc -l )

    pair_all=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
    n_pair_all=${#pair_all[*]}
	
    if [ ${n_pair_all} -gt 0 ]; then
	for i in ${pair_all[*]}; do
	    head -$i ${dist}/${pairs} | tail -1 | awk '{printf("%d %d\n",$1+'$nc',$2+'$nc')}'
	done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_pairs.txt

	for i in ${pair_all[*]}; do
	    pair=$( head -$i ${dist}/${pairs} | tail -1 | awk '{printf("%d %d",$1+'$nc',$2+'$nc')}' )

	    echo "draw_line_between_ca_ca " ${pair[*]} " 0.1"

	done > ${anomaly}/draw_line_between_ca_ca_anomaly_sp=${r}
    fi

    pair_top10=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | head -10 | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
    n_pair_top10=${#pair_top10[*]}

    if [ ${n_pair_top10} -gt 0 ]; then
	for i in ${pair_top10[*]}; do
	    head -$i ${dist}/${pairs} | tail -1 | awk '{printf("%d %d\n",$1+'$nc',$2+'$nc')}'
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
		head -$i ${dist}/${pairs} | tail -1 | awk '{printf("%d %d\n",$1+'$nc',$2+'$nc')}'
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
		    head -$i ${dist}/${pairs} | tail -1 | awk '{printf("%d %d\n",$1+'$nc',$2+'$nc')}'
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
			head -$i ${dist}/${pairs} | tail -1 | awk '{printf("%d %d\n",$1+'$nc',$2+'$nc')}'
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
			    head -$i ${dist}/${pairs} | tail -1 | awk '{printf("%d %d\n",$1+'$nc',$2+'$nc')}'
			done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top41-100_pairs.txt
		    fi

		    if [ ${num_anomaly} -gt 100 ]; then
			n=`expr ${num_anomaly} - 100`

			pair_top100=( $( sort -nrk 4,4 ${anomaly}/a_d_r-r_sp=${r}_anomaly.txt | awk '$4>0.0' | tail -${n} | awk '$1 ~ /^[0-9]+$/{print $1}' ) )
			n_pair_top100=${#pair_top100[*]}
		    
			if [ ${n_pair_top100} -gt 0 ]; then
			    for i in ${pair_top100[*]}; do
				head -$i ${dist}/${pairs} | tail -1 | awk '{printf("%d %d\n",$1+'$nc',$2+'$nc')}'
			    done > ${anomaly}/a_d_r-r_sp=${r}_anomaly_top101_pairs.txt
			fi
		    fi
		fi
	    fi
	fi
    fi
done
