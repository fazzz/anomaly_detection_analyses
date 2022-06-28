#!/bin/sh

if [ ! -f whole.xtc ]; then
    gmx trjconv -f ../production/production.xtc \
                -s ../production/production.tpr -o whole.xtc -n protein.ndx -pbc whole
fi

if [ ! -f cluster.xtc ]; then
    gmx trjconv -f whole.xtc \
                -s ../production/production.tpr -o cluster.xtc -n protein.ndx -pbc cluster
fi

if [ ! -f ave.pdb ]; then
    gmx rmsf -f cluster.xtc -s ../production/production.tpr -n protein.ndx -ox ave.pdb -o rmsf.xvg -res
    sed -i 's/MC/ C/g' ave.pdb
fi

if [ ! -f superimposed-ave.xtc ]; then
    gmx trjconv -f cluster.xtc -s ave.pdb -n protein.ndx -o superimposed-ave.xtc
fi

gmx trjconv -f superimposed-ave.xtc -s ave.pdb -n protein.ndx -box 12.0 12.0 12.0 -o new_box.xtc

