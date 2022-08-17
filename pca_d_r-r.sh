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

if [ ! -d ${pca} ]; then
    mkdir ${pca}
fi

for r in ${sparsity[*]}; do
    awk '{printf("%4d %4d\n",$1-'$nc',$2-'$nc')}' ${anomaly}/a_d_r-r_sp=${r}_anomaly_pairs.txt \
	> ${anomaly}/a_d_r-r_sp=${r}_anomaly_pairs_raw.txt

    python3 pca_d_r-r.py \
	superimposed-ave.xtc ../../${B}/${analyses_B}/superimposed-ave.xtc \
	nst-ave.pdb ${anomaly}/a_d_r-r_sp=${r}_anomaly_pairs_raw.txt \
	${pca}/pca_contact_distances_sp=${r}
done
