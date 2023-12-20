#$ -S /bin/sh
#$ -V
#$ -q all.q@pdis16
#$ -j y
#$ -o assl_d_r-rx_5.o
#$ -cwd
#$ -N assl_d_r-r

sparsity=( 0.90 0.80 0.70 0.60 0.50 0.40 )

if [ ! -d dist_r-r_5 ]; then
    mkdir dist_r-r_5
fi

cd dist_r-r_5

if [ ! -f r-r_dist_union-open-close.txt ]; then
    python3 ../contact_distance_union-open-close.py \
	--cutoff 0.8 --ij 3 \
	../superimposed-ave.xtc \
	../nst-ave.pdb \
	../../../close/analyses_1/nst-ave.pdb \
	r-r_pairs_union-open-close.txt \
	r-r_dist_union-open-close.txt
fi

ndist=`wc -l r-r_pairs_union-open-close.txt | awk '{print $1}'`

cd ../../../close/analyses_1/

if [ ! -d dist_r-r_5 ]; then
    mkdir dist_r-r_5
fi

cd dist_r-r_5

if [ ! -f r-r_dist_union-open-close.txt ]; then
    python3 ../../../open/analyses_1/contact_distance_union-open-close.py \
	--cutoff 0.8 --ij 3 \
	../superimposed-ave.xtc \
	../../../open/analyses_1/nst-ave.pdb \
	../nst-ave.pdb \
	r-r_pairs_union-open-close.txt \
	r-r_dist_union-open-close.txt
fi

ndist_5=`wc -l r-r_pairs_union-open-close.txt | awk '{print $1}'`

if [ ${ndist} != ${ndist_5} ]; then
    echo "Number of distnces id illegal."
    exit
fi

echo "ndist:${ndist}"

cd ../../../open/analyses_1

if [ ! -d anomaly_d_r-r_5 ]; then
    mkdir -p anomaly_d_r-r_5
fi

cd anomaly_d_r-r_5

echo "assl calculations will be started..."

for r in ${sparsity[*]}; do
  echo "assl with r=\${r} start"
  assl2 -Sparsity ${r} -ndim ${ndist} \
                             ../dist_r-r_5/r-r_dist_union-open-close.txt \
      ../../../close/analyses_1/dist_r-r_5/r-r_dist_union-open-close.txt \
      > a_d_r-r_sp=${r}.txt
   echo "assl with r=${r} done"
   ../postprocess.sh a_d_r-r_sp=${r}.txt
done
