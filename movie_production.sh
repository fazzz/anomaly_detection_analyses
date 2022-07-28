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
            -s protein_viewpoint.pdb -o x.pdb -skip 500 -sep

ls x*.pdb | parallel ./illust.sh

rm x*.pdb

for p in *.png ; do
    i=$( basename "${p}" .png | awk -F"x" '{printf("%d\n"), $2}')
    i=$( expr ${i} \* 5 )

    convert -geometry 800x500 -pointsize 50 -gravity south -font Times-Roman -annotate 0 "${i}ns" -fill black ${p} $( printf "%05d" ${i} ).tga

    rm ${p}
done

convert -layers optimize -loop 0 -delay 10 $( ls -v *.tga ) production.gif

rm *.tga

#ffmpeg -i production.gif -movflags faststart -pix_fmt yuv420p \
#       -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" production.mp4
