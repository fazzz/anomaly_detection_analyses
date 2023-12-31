#!/bin/sh

opt=( dummy parafilename )
nopt=${#opt[*]}
if [ $# -le `expr ${nopt} - 2` ]; then
    echo "USAGE: $0" ${opt[*]:1:${nopt}}
    echo $*
    exit
fi

num=1
while [ $num -le `expr ${nopt} - 1` ]; do
    eval ${opt[$num]}=$1
    shift 1
    num=`expr $num + 1`
done

source ${parafilename}

if [ ! -d ${mol} ]; then
    mkdir -p ${mol}
fi

cd ${mol}

for r in ${sparsity[*]}; do
    cat <<EOF > mol_${tcl_name}_sp=${r}_${A}.tcl
axes location off

proc draw_line_between_ca_ca {resi resj radi} {
    set atomi [atomselect 0 "name CA and resid \${resi}"]
    set atomj [atomselect 0 "name CA and resid \${resj}"]

    set coordi [ lindex [\$atomi get {x y z}] 0 ]
    set coordj [ lindex [\$atomj get {x y z}] 0 ]

    draw cylinder \$coordi \$coordj radius \$radi resolution 20
    draw sphere \$coordi radius 0.3 resolution 20
    draw sphere \$coordj radius 0.3 resolution 20
}

mol new {../protein_nst-ave_viewpoint.pdb} type {pdb}

mol modcolor    0 0 ColorID 2
mol modstyle    0 0 Newcartoon
mol modmaterial 0 0 Transparent

graphics 0 color red
EOF
    cat ../${anomaly}/draw_line_between_ca_ca_anomaly_sp=${r} >> \
	mol_${tcl_name}_sp=${r}_${A}.tcl

    cat <<EOF >> mol_${tcl_name}_sp=${r}_${A}.tcl
set filename nst-ave-a-d_r-r_sp=${r}_${A}
render Tachyon \$filename
"/Applications/VMD\ 1.9.4.app/Contents/vmd/tachyon_MACOSXX86" \\
    -aasamples 12 \$filename \\
    -format TARGA -res 1600 1200 \\
    -o \$filename.tga

quit
EOF

########################################################################################

    cat <<EOF > mol_${tcl_name}_sp=${r}_${B}.tcl
axes location off

proc draw_line_between_ca_ca {resi resj radi} {
    set atomi [atomselect 0 "name CA and resid \${resi}"]
    set atomj [atomselect 0 "name CA and resid \${resj}"]

    set coordi [ lindex [\$atomi get {x y z}] 0 ]
    set coordj [ lindex [\$atomj get {x y z}] 0 ]

    draw cylinder \$coordi \$coordj radius \$radi resolution 20
    draw sphere \$coordi radius 0.3 resolution 20
    draw sphere \$coordj radius 0.3 resolution 20
}

mol new {../protein_nst-ave_viewpoint_${B}.pdb} type {pdb}

mol modcolor    0 0 ColorID 2
mol modstyle    0 0 Newcartoon
mol modmaterial 0 0 Transparent

graphics 0 color red
EOF
    cat ../${anomaly}/draw_line_between_ca_ca_anomaly_sp=${r} >> \
	mol_${tcl_name}_sp=${r}_${B}.tcl

    cat <<EOF >> mol_${tcl_name}_sp=${r}_${B}.tcl
set filename nst-ave-a-d_r-r_sp=${r}_${B}
render Tachyon \$filename
"/Applications/VMD\ 1.9.4.app/Contents/vmd/tachyon_MACOSXX86" \\
    -aasamples 12 \$filename \\
    -format TARGA -res 1600 1200 \\
    -o \$filename.tga

quit
EOF
done
