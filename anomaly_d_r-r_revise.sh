#$ -S /bin/sh
#$ -V
#$ -q all.q@pdis16
#$ -j y
#$ -o assl_d_r-rx_3.o
#$ -cwd
#$ -N assl_d_r-r

#sparsity=( 0.90 0.80 0.70 0.60 0.50 0.40 )
#sparsity=( 0.96 0.94 0.92 )
sparsity=( 0.93 0.91 )

if [ ! -d dist_r-r_3 ]; then
    mkdir dist_r-r_3
fi

cd dist_r-r_3

if [ ! -f r-r_dist_union-open-close.txt ]; then
    python3 ../contact_distance_union-open-close.py \
	--cutoff 0.8 --ij 10 \
	../superimposed-ave.xtc \
	../nst-ave.pdb \
	../../../close/analyses_1/nst-ave.pdb \
	r-r_pairs_union-open-close.txt \
	r-r_dist_union-open-close.txt
fi

ndist=`wc -l r-r_pairs_union-open-close.txt | awk '{print $1}'`

cd ../../../close/analyses_1/

if [ ! -d dist_r-r_3 ]; then
    mkdir dist_r-r_3
fi

cd dist_r-r_3

if [ ! -f r-r_dist_union-open-close.txt ]; then
    python3 ../../../open/analyses_1/contact_distance_union-open-close.py \
	--cutoff 0.8 --ij 10 \
	../superimposed-ave.xtc \
	../../../open/analyses_1/nst-ave.pdb \
	../nst-ave.pdb \
	r-r_pairs_union-open-close.txt \
	r-r_dist_union-open-close.txt
fi

ndist_3=`wc -l r-r_pairs_union-open-close.txt | awk '{print $1}'`

if [ ${ndist} != ${ndist_3} ]; then
    echo "Number of distnces id illegal."
    exit
fi

echo "ndist:${ndist}"

cd ../../../open/analyses_1

if [ ! -d anomaly_d_r-r_3 ]; then
    mkdir -p anomaly_d_r-r_3
fi

cd anomaly_d_r-r_3

echo "assl calculations will be started..."

for r in ${sparsity[*]}; do
  echo "assl with r=\${r} start"
  assl2 -Sparsity ${r} -ndim ${ndist} \
                             ../dist_r-r_3/r-r_dist_union-open-close.txt \
      ../../../close/analyses_1/dist_r-r_3/r-r_dist_union-open-close.txt \
      > a_d_r-r_sp=${r}.txt
   echo "assl with r=${r} done"
   ../postprocess.sh a_d_r-r_sp=${r}.txt
done
