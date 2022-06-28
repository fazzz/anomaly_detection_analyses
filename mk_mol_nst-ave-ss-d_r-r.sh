#!/bin/sh

sparsity=( 0.90 0.80 0.70 0.60 0.50 0.40 )

anomaly=anomaly_d_r-r
dist=dist_r-r

for r in ${sparsity[*]}; do

    cat <<EOF > mol_nst-ave-ss-d_r-r_sp=${r}.tcl
axes location off

proc draw_line_between_ca_ca {resi resj radi} {
    set atomi [atomselect 0 "name CA and resid \${resi}"]
    set atomj [atomselect 0 "name CA and resid \${resj}"]

    set coordi [ lindex [\$atomi get {x y z}] 0 ]
    set coordj [ lindex [\$atomj get {x y z}] 0 ]

    draw cylinder \$coordi \$coordj radius \$radi resolution 20
}

mol new {protein_nst-ave_viewpoint.pdb} type {pdb}

mol modcolor    0 0 ColorID 2
mol modstyle    0 0 Newcartoon
mol modmaterial 0 0 Transparent

graphics 0 color red

EOF

    cat ${anomaly}/draw_line_between_ca_ca_open_sp=${r} >> mol_nst-ave-ss-d_r-r_sp=${r}.tcl

    cat <<EOF >> mol_nst-ave-ss-d_r-r_sp=${r}.tcl

graphics 0 color blue

EOF

    cat ${anomaly}/draw_line_between_ca_ca_close_sp=${r} >> mol_nst-ave-ss-d_r-r_sp=${r}.tcl

    cat <<EOF >> mol_nst-ave-ss-d_r-r_sp=${r}.tcl

set filename nst-ave-ss-d_r-r_sp=${r}
render Tachyon \$filename
"/Applications/VMD\ 1.9.4.app/Contents/vmd/tachyon_MACOSXX86" \\
    -aasamples 12 \$filename \\
    -format TARGA -res 1600 1200 \\
    -o \$filename.tga

quit
EOF

done
