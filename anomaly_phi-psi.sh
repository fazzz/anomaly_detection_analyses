#$ -S /bin/sh
#$ -V
#$ -q all.q@pdis18
#$ -j y
#$ -o assl_phi_psix.o
#$ -cwd
#$ -N assl_phi_psi

#sparsity=( 0.90 0.80 0.70 0.60 0.50 )
sparsity=( 0.40 0.30 0.20 0.10 )
nres=163
n=`expr ${nres} \* 4`

if [ ! -d phi-psi ]; then
    mkdir phi-psi
fi

cd phi-psi

if [ ! -f sin_cos_phi-psi.txt ]; then
    python3 ../sin-cos_phi-psi.py \
	../superimposed-ave.xtc \
	../nst-ave.pdb \
	sin_cos_phi-psi.txt
fi

cd ../../../close/analyses_2/

if [ ! -d phi-psi ]; then
    mkdir phi-psi
fi

cd phi-psi

if [ ! -f phi-psi.txt ]; then
    python3 ../../../open/analyses_2/sin-cos_phi-psi.py \
	../superimposed-ave.xtc \
	../nst-ave.pdb \
	sin_cos_phi-psi.txt
fi

cd ../../../open/analyses_2

if [ ! -d anomaly_phi_psi ]; then
    mkdir -p anomaly_phi_psi
fi

cd anomaly_phi_psi

echo "assl calculations will be started..."

for r in ${sparsity[*]}; do
  echo "assl with r=${r} start"
  assl2 -Sparsity ${r} -ndim ${n} \
                             ../phi-psi/sin_cos_phi-psi.txt \
      ../../../close/analyses_2/phi-psi/sin_cos_phi-psi.txt \
      > a_phi_psi_sp=${r}.txt
   echo "assl with r=${r} done"
   ../postprocess.sh a_phi_psi_sp=${r}.txt
done
