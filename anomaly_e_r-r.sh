#!/bin/sh

sparsity=( 0.90 0.80 0.70 0.60 0.50 0.40 0.30 )
nres=164

cd eneres

nresm=`expr ${nres} - 1`;
for i in `seq -w 001 ${nresm}`; do
    awk '{printf("%8.3f\n",$2)}' res$i.txt > res$i.temp
done
awk '{printf("%8.3f \n",$2)}' res${nres}.txt > res${nres}.temp

paste -d" " *.temp > ene_res.txt

awk '{sum=0;for(i=1;i<=NF;++i){sum=sum+$i;}printf("%8.3f \n",sum)}' ene_res.txt > ene_r_all.txt

rm *.temp

cd ../../../close/analyses_2/eneres

nresm=`expr ${nres} - 1`;
for i in `seq -w 001 ${nresm}`; do
    awk '{printf("%8.3f\n",$2)}' res$i.txt > res$i.temp
done
awk '{printf("%8.3f \n",$2)}' res${nres}.txt > res${nres}.temp

paste -d" " *.temp > ene_res.txt

awk '{sum=0;for(i=1;i<=NF;++i){sum=sum+$i;}printf("%8.3f \n",sum)}' ene_res.txt > ene_r_all.txt

rm *.temp

cd ../../../open/analyses_2

if [ ! -d anomaly_e_r-r ]; then
    mkdir -p anomaly_e_r-r
fi

cd anomaly_e_r-r

echo "assl calculations will be started..."

cat <<EOF > job_assl.sh
#$ -S /bin/sh
#$ -V
#$ -q all.q@pdis17
#$ -j y
#$ -o assl_e_r-r.o
#$ -cwd
#$ -N assl_e_r-r

for r in ${sparsity[*]}; do
  echo "assl with r=\${r} start"
  assl2 -Sparsity \${r} -ndim ${nres} \\
      ../eneres/ene_res.txt \\
      ../../../close/analyses_2/eneres/ene_res.txt \\
      > a_e_r-r_sp=\${r}.txt
   echo "assl with r=\${r} done"
   ../postprocess.sh a_e_r-r_sp=\${r}.txt
done

EOF

qsub job_assl.sh
