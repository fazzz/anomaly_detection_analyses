#!/bin/sh

#sparsity=( 0.70 0.60 0.50 0.40 0.30 )
#sparsity=( 0.90 0.80 0.75 )
sparsity=( 0.85 )

if [ ! -d dist_r-r ]; then
    mkdir dist_r-r
fi

cd dist_r-r

if [ ! -f r-r_dist_union-open-close.txt ]; then
    python3 ../contact_distance_union-open-close.py \
	../superimposed-ave-skip10.xtc \
	../protein_nst-ave.pdb \
	../../../close/analyses_1/protein_nst-ave.pdb \
	r-r_pairs_union-open-close.txt \
	r-r_dist_union-open-close.txt
fi

ndist=`wc -l r-r_pairs_union-open-close.txt | awk '{print $1}'`

cd ../../../close/analyses_1/

if [ ! -d dist_r-r ]; then
    mkdir dist_r-r
fi

cd dist_r-r

if [ ! -f r-r_dist_union-open-close.txt ]; then
    python3 ../../../open/analyses_1/contact_distance_union-open-close.py \
	../superimposed-ave-skip10.xtc \
	../../../open/analyses_1/protein_nst-ave.pdb \
	../protein_nst-ave.pdb \
	r-r_pairs_union-open-close.txt \
	r-r_dist_union-open-close.txt
fi

ndist_2=`wc -l r-r_pairs_union-open-close.txt | awk '{print $1}'`

if [ ${ndist} != ${ndist_2} ]; then
    echo "Number of distnces id illegal."
    exit
fi

echo "ndist:${ndist}"

cd ../../../open/analyses_1

if [ ! -d anomaly_d_r-r ]; then
    mkdir -p anomaly_d_r-r
fi

cd anomaly_d_r-r

echo "assl calculations will be started..."

cat <<EOF > job_assl.sh
#$ -S /bin/sh
#$ -V
#$ -q all.q@pdis17
#$ -j y
#$ -o assl_d_r-r.o
#$ -cwd
#$ -N assl_d_r-r

for r in ${sparsity[*]}; do
  echo "assl with r=\${r} start"
  assl2 -Sparsity \${r} -ndim ${ndist} \\
                             ../dist_r-r/r-r_dist_union-open-close.txt \\
      ../../../close/analyses_1/dist_r-r/r-r_dist_union-open-close.txt \\
      > a_d_r-r_sp=\${r}.txt
   echo "assl with r=\${r} done"
   ../postprocess.sh a_d_r-r_sp=\${r}.txt
done

EOF

qsub job_assl.sh
