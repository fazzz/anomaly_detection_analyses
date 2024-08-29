#!/bin/sh

if [ ! -f whole.xtc ]; then
    gmx trjconv -f ../production/production.xtc \
                -s ../production/production.tpr -o whole.xtc -n protein.ndx -pbc whole
fi

if [ ! -f cluster.xtc ]; then
gmx trjconv -f whole.xtc \
            -s ../production/production.tpr -o cluster.xtc -n protein.ndx -pbc cluster
fi

gmx trjconv -f cluster.xtc -fit rot+trans \
            -s protein_viewpoint.pdb -o x.pdb -skip 5000 -sep

ls x*.pdb | parallel ./illust.sh

rm x*.pdb

convert -layers optimize -loop 0 -delay 10 $( ls -v *.png ) production_.gif

#ffmpeg -i production.gif -movflags faststart -pix_fmt yuv420p \
#       -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" production.mp4
