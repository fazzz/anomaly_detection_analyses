#!/bin/sh

sparsity=( 0.70 0.60 0.50 0.40 0.30 )

if [ ! -d dist_ca-ca ]; then
    mkdir dist_ca-ca
fi

cd dist_ca-ca

python3 ../ca-ca_distance_pairs_union_of_2states.py \
    ../protein_nst-ave.pdb \
    ../../../close/analyses_2/protein_nst-ave.pdb \
    ca-ca_pairs_union-open-close.txt

ndist=`wc -l ca-ca_pairs_union-open-close.txt | awk '{print $1}'`

python3 ../ca-ca_distance_union-open-close.py \
    ../superimposed-ave-skip100.xtc \
    ../protein_nst-ave.pdb \
    ../../../close/analyses_2/protein_nst-ave.pdb \
    ca-ca_distance_union-open-close-skip100.txt

cd ../../../close/analyses_2/

if [ ! -d dist_ca-ca ]; then
    mkdir dist_ca-ca
fi

cd dist_ca-ca

python3 ../../../open/analyses_2/ca-ca_distance_pairs_union_of_2states.py \
    ../../../open/analyses_2/protein_nst-ave.pdb \
    ../protein_nst-ave.pdb \
    ca-ca_pairs_union-open-close.txt

ndist_2=`wc -l ca-ca_pairs_union-open-close.txt | awk '{print $1}'`

if [ ${ndist} != ${ndist_2} ]; then
    echo "Number of distnces id illegal."
    exit
fi

echo "ndist:${ndist}"

python3 ../../../open/analyses_2/ca-ca_distance_union-open-close.py \
    ../superimposed-ave-skip100.xtc \
    ../../../open/analyses_2/protein_nst-ave.pdb \
    ../protein_nst-ave.pdb \
    ca-ca_distance_union-open-close-skip100.txt

cd ../../../open/analyses_2

if [ ! -d anomaly_d_ca-ca ]; then
    mkdir -p anomaly_d_ca-ca
fi

cd anomaly_d_ca-ca

echo "assl calculations will be started..."

cat <<EOF > job_assl.sh
#$ -S /bin/sh
#$ -V
#$ -q all.q@pdis17
#$ -j y
#$ -o assl_d_ca-ca.o
#$ -cwd
#$ -N assl_d_ca-ca

for r in ${sparsity[*]}; do
  echo "assl with r=\${r} start"
  assl2 -Sparsity \${r} -ndim ${ndist} \\
                             ../dist_ca-ca/ca-ca_distance_union-open-close-skip100.txt \\
      ../../../close/analyses_2/dist_ca-ca/ca-ca_distance_union-open-close-skip100.txt \\
      > a_d_ca-ca_sp=\${r}.txt
   echo "assl with r=\${r} done"
   ../postprocess.sh a_d_ca-ca_sp=\${r}.txt
done

EOF

qsub job_assl.sh
