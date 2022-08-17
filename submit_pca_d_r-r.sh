#!/bin/sh

opt=( dummy parafilename que )
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

cat <<EOF > ${pca}/pca_$( basename ${parafilename} .sh ).sh
#$ -V
#$ -q all.q@pdis${que}
#$ -j y
#$ -o pca_d_r-r.o
#$ -cwd
#$ -N pca_d_r-r

source ${parafilename}

for r in \${sparsity[*]}; do
    awk '{printf("%4d %4d\n",\$1-'\$nc',\$2-'\$nc')}' \\
        \${anomaly}/a_d_r-r_sp=\${r}_anomaly_pairs.txt \\
      > \${anomaly}/a_d_r-r_sp=\${r}_anomaly_pairs_raw.txt

    python3 pca_d_r-r.py \\
	../../\${A}/${analyses_A}/superimposed-ave.xtc \\
	../../\${B}/${analyses_B}/superimposed-ave.xtc \\
	../\${analyses_A}/nst-ave.pdb \\
	\${anomaly}/a_d_r-r_sp=\${r}_anomaly_pairs_raw.txt \\
	\${pca}/pca_contact_distances_sp=\${r}
done
EOF

qsub ${pca}/pca_$( basename ${parafilename} .sh ).sh
