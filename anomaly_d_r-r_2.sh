#$ -S /bin/sh
#$ -V
#$ -q all.q@pdis17
#$ -j y
#$ -o assl_d_r-rx_2.o
#$ -cwd
#$ -N assl_d_r-r

sparsity=( 0.90 0.80 0.70 0.60 0.50 0.40 )

if [ ! -d dist_r-r_2 ]; then
    mkdir dist_r-r_2
fi

cd dist_r-r_2

if [ ! -f r-r_dist_union-open-close.txt ]; then
    python3 ../contact_distance_union-open-close.py \
	--cutoff 0.6 --ij 10 \
	../superimposed-ave.xtc \
	../nst-ave.pdb \
	../../../close/analyses_2/nst-ave.pdb \
	r-r_pairs_union-open-close.txt \
	r-r_dist_union-open-close.txt
fi

ndist=`wc -l r-r_pairs_union-open-close.txt | awk '{print $1}'`

cd ../../../close/analyses_2/

if [ ! -d dist_r-r_2 ]; then
    mkdir dist_r-r_2
fi

cd dist_r-r_2

if [ ! -f r-r_dist_union-open-close.txt ]; then
    python3 ../../../open/analyses_2/contact_distance_union-open-close.py \
	--cutoff 0.6 --ij 10 \
	../superimposed-ave.xtc \
	../../../open/analyses_2/nst-ave.pdb \
	../nst-ave.pdb \
	r-r_pairs_union-open-close.txt \
	r-r_dist_union-open-close.txt
fi

ndist_2=`wc -l r-r_pairs_union-open-close.txt | awk '{print $1}'`

if [ ${ndist} != ${ndist_2} ]; then
    echo "Number of distnces id illegal."
    exit
fi

echo "ndist:${ndist}"

cd ../../../open/analyses_2

if [ ! -d anomaly_d_r-r_2 ]; then
    mkdir -p anomaly_d_r-r_2
fi

cd anomaly_d_r-r_2

echo "assl calculations will be started..."

for r in ${sparsity[*]}; do
  echo "assl with r=\${r} start"
  assl2 -Sparsity ${r} -ndim ${ndist} \
                             ../dist_r-r_2/r-r_dist_union-open-close.txt \
      ../../../close/analyses_2/dist_r-r_2/r-r_dist_union-open-close.txt \
      > a_d_r-r_sp=${r}.txt
   echo "assl with r=${r} done"
   ../postprocess.sh a_d_r-r_sp=${r}.txt
done
