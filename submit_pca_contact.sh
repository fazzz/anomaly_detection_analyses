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

if [ ! -d fig_pca_contact ]; then
    mkdir fig_pca_contact
fi

cat <<EOF > fig_pca_contact/pca_contact.sh
#$ -V
#$ -q all.q@pdis${que}
#$ -j y
#$ -o pca_c.o
#$ -cwd
#$ -N pca_c

python3 pca_native-contact.py \\
--cutoff ${cutoff} --ij ${ij} \\
../../${A}/${analyses_A}/superimposed-ave.xtc \\
../../${B}/${analyses_B}/superimposed-ave.xtc \\
../${analyses_A}/nst-ave.pdb \\
../${analyses_B}/nst-ave.pdb \\
fig_pca_contact/pca_contact \\
EOF

qsub fig_pca_contact/pca_contact.sh
