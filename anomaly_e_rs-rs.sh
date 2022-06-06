#!/bin/sh

#sparsity=( 0.70 0.60 0.50 0.40 0.30 )
sparsity=( 0.20 0.10 0.01 )
nres=164

cd eneres_scaled

nresm=`expr ${nres} - 1`;
for i in `seq -w 001 ${nresm}`; do
    awk '{printf("%8.3f\n",$2)}' res+sol$i.txt > res+sol$i.temp
done
awk '{printf("%8.3f \n",$2)}' res+sol${nres}.txt > res+sol${nres}.temp

paste -d" " *.temp > ene_res+sol.txt

awk '{sum=0;for(i=1;i<=NF;++i){sum=sum+$i;}printf("%8.3f \n",sum)}' ene_res+sol.txt > ene_rs_all.txt

rm *.temp

cd ../../../close/analyses_2/eneres_scaled

nresm=`expr ${nres} - 1`;
for i in `seq -w 001 ${nresm}`; do
    awk '{printf("%8.3f\n",$2)}' res+sol$i.txt > res+sol$i.temp
done
awk '{printf("%8.3f \n",$2)}' res+sol${nres}.txt > res+sol${nres}.temp

paste -d" " *.temp > ene_res+sol.txt

awk '{sum=0;for(i=1;i<=NF;++i){sum=sum+$i;}printf("%8.3f \n",sum)}' ene_res+sol.txt > ene_rs_all.txt

rm *.temp

cd ../../../open/analyses_2

if [ ! -d anomaly_e_rs-rs ]; then
    mkdir -p anomaly_e_rs-rs
fi

cd anomaly_e_rs-rs

echo "assl calculations will be started..."

cat <<EOF > job_assl.sh
#$ -S /bin/sh
#$ -V
#$ -q all.q@pdis17
#$ -j y
#$ -o assl_e_rs-rs.o
#$ -cwd
#$ -N assl_e_rs-rs

for r in ${sparsity[*]}; do
    echo "assl with r=\${r} start"
    assl2 -Sparsity \${r} -ndim ${nres} \\
        ../eneres_scaled/ene_res+sol.txt \\
        ../../../close/analyses_2/eneres_scaled/ene_res+sol.txt \\
        > a_e_rs-rs_sp=\${r}.txt
    echo "assl with r=\${r} done"
    ../postprocess.sh a_e_rs-rs_sp=\${r}.txt
done

EOF

qsub job_assl.sh
