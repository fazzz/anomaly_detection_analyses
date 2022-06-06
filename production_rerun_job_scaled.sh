#!/bin/sh

if [ ! -d eneres_scaled ]; then
    mkdir eneres_scaled
fi

function jobsubmit() {
    ofile=eneres_scaled/eneres${1}-${2}.o

    for i in `seq -w ${1} ${2}`; do
	cat <<EOF > eneres_scaled/select${i}.txt
wores = ( not resnr ${i} ) and group "Protein";
wores;
res = resnr ${i};
res;
group "System";
group "Protein";
group "SOL";
EOF
    done

    cat <<EOF > eneres_scaled/eneres${1}-${2}.sh
#$ -S /bin/sh
#$ -V
#$ -q all.q@pdis${3}
#$ -j y
#$ -o ${ofile}
#$ -cwd
#$ -N eneres_${1}-${2}

cd eneres_scaled/

for i in \`seq -w ${1} ${2}\`; do
    gmx_mpi select \\
     -f  ../../production_2/production.gro \\
     -s  ../../production_2/production.tpr \\
     -sf select\${i}.txt \\
     -on res\${i}.ndx

    gmx_mpi grompp -maxwarn 1 \\
     -f  production_rerun.mdp \\
     -p  ../../preparation/input/topol.top \\
     -c  ../../preparation/step10_final_density_stabilization/final_density_stabilization.gro \\
     -o  production_rerun\${i}.tpr \\
     -po production_rerun\${i}.mdp \\
     -n  res\${i}.ndx

    mpirun -np 8 gmx_mpi mdrun  \\
     -rerun  ../production_scaled.xtc \\
     -deffnm ener\${i} \\
     -s      production_rerun\${i}.tpr
done
EOF

    qsub eneres_scaled/eneres${1}-${2}.sh
}

if [ ! -f production_scaled.xtc ]; then
    gmx trjconv -f ../production_2/production.xtc \
                -s ../production_2/production.tpr -o production_scaled.xtc -skip 10
fi

cp production_rerun.mdp eneres_scaled

jobsubmit 001 055 20
jobsubmit 056 110 21
jobsubmit 111 164 22

#i="001"
#for f in `seq -w 011 11 164`; do
#    jobsubmit ${i} ${f}
#
#    i=`expr $f + 1`
#    i=$( printf "%03d\n" ${i} )
#done
#
#if [ ${f} -lt 164 ]; then
#    f=`expr $f + 1`
#    f=$( printf "%03d\n" ${f} )
#    jobsubmit ${f} 164
#fi

