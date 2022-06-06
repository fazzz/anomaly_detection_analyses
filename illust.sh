#!/bin/sh

opt=( dummy pdb )
nopt=${#opt[*]}
if [ $# -le `expr ${nopt} - 2` ]; then
    echo "USAGE: $0" ${opt[*]:1:${nopt}}
    echo "Your Command"$*
    exit
fi

num=1
while [ $num -le `expr ${nopt} - 1` ]; do
    eval ${opt[$num]}=$1
    shift 1
    num=`expr $num + 1`
done

pdbbase=$( basename ${pdb} .pdb )

cat <<EOF > inp${pdbbase}
read
${pdbbase}.pdb
HETATM-----HOH-- 0,9999, 0.5,0.5,0.5, 0.0
ATOM  -H-------- 0,9999, 0.5,0.5,0.5, 0.0
ATOM  H--------- 0,9999, 0.5,0.5,0.5, 0.0
ATOM  -C-------A 0,9999, 1.0,0.6,0.6, 1.6
ATOM  -S-------A 0,9999, 1.0,0.5,0.5, 1.8
ATOM  ---------A 0,9999, 1.0,0.5,0.5, 1.5
ATOM  -C-------C 0,9999, 1.0,0.6,0.6, 1.6
ATOM  -S-------C 0,9999, 1.0,0.5,0.5, 1.8
ATOM  ---------C 0,9999, 1.0,0.5,0.5, 1.5
ATOM  -C-------- 0,9999, 1.0,0.8,0.6, 1.6
ATOM  -S-------- 0,9999, 1.0,0.7,0.5, 1.8
ATOM  ---------- 0,9999, 1.0,0.7,0.5, 1.5
HETATMFE---HEM-- 0,9999, 1.0,0.8,0.0, 1.8
HETATM-C---HEM-- 0,9999, 1.0,0.3,0.3, 1.6
HETATM-----HEM-- 0,9999, 1.0,0.1,0.1, 1.5
END
center
auto
trans
0.,0.,0.
scale
12.0
zrot
90.
wor
1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0
1,0.0023,2.0,1.0,0.2
-30,-30
illustrate
3.0,10.0,4,0.0,5.0
3.0,10.0
3.0,8.0,6000.
calculate
${pdbbase}.png
EOF

~/opt/bin/illustrate < inp${pdbbase}

rm inp${pdbbase}

