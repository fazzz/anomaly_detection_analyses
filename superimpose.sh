#!/bin/sh

if [ ! -f whole.xtc ]; then
    gmx trjconv -f ../production/production.xtc \
                -s ../production/production.tpr -o whole.xtc -n protein.ndx -pbc whole
fi

if [ ! -f cluster.xtc ]; then
    gmx trjconv -f whole.xtc \
                -s ../production/production.tpr -o cluster.xtc -n protein.ndx -pbc cluster
fi

gmx rmsf -f cluster.xtc -s ../production/production.tpr -n protein.ndx -ox ave.pdb -o rmsf.xvg -res
sed -i 's/MC/ C/g' ave.pdb
gmx trjconv -f cluster.xtc -s ave.pdb -n protein.ndx -o superimposed-ave.xtc
gmx rms -f superimposed-ave.xtc -s ave.pdb -n protein.ndx -o rmsd-ave.xvg
gmx rms -f superimposed-ave.xtc -s ../production/production.tpr -n protein.ndx -o rmsd.xvg

#i=2
#while [ ${i} -le 5 ]; 
#do
#    gmx rmsf -f superimposed-ave.xtc -s ../production/production.tpr -n protein.ndx -ox ave_${i}.pdb
#    sed -i 's/MC/ C/g' ave_${i}.pdb
#    gmx trjconv -f superimposed-ave.xtc -s ave_${i}.pdb -n protein.ndx -o superimposed-ave.xtc
#    gmx rms -f superimposed-ave.xtc -s ../production/production.tpr -n protein.ndx -o rmsd_${i}.xvg
#
#    i=`expr ${i} + 1`
#done
