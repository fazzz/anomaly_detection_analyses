#!/bin/bash

opt=( dummy sparsity resid )
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

if [ ! -f anomaly_e_r-r/reslist_sp=${sparsity}_${resid}.txt ]; then

    cd anomaly_e_r-r

    awk 'BEGIN{print "A "}$1=='$resid'{print $2}$2=='$resid'{print $1}' \
	a_e_r-r_sp=${sparsity}_ss_A.txt | tr "\n" " " \
	> reslist_sp=${sparsity}_${resid}.txt
    echo "\n" >> reslist_sp=${sparsity}_${resid}.txt

    awk 'BEGIN{print "B "}$1=='$resid'{print $2}$2=='$resid'{print $1}' \
	a_e_r-r_sp=${sparsity}_ss_B.txt | tr "\n" " " \
	>> reslist_sp=${sparsity}_${resid}.txt
    echo "\n" >> reslist_sp=${sparsity}_${resid}.txt

    cd ..
fi

N_seqA=$( cat anomaly_e_r-r/reslist_sp=${sparsity}_${resid}.txt | awk '$1~/A/{print NF-1}' )
N_seqB=$( cat anomaly_e_r-r/reslist_sp=${sparsity}_${resid}.txt | awk '$1~/B/{print NF-1}' )

if [ ${N_seqA} -gt 0 ]; then
    seq_A=$( cat anomaly_e_r-r/reslist_sp=${sparsity}_${resid}.txt | \
	     awk '$1~/A/{for(i=2;i<NF;++i){printf("resid %d or ",$i)}printf("resid %d",$NF)}' )
fi

if [ ${N_seqB} -gt 0 ]; then
    seq_B=$( cat anomaly_e_r-r/reslist_sp=${sparsity}_${resid}.txt | \
	     awk '$1~/B/{for(i=2;i<NF;++i){printf("resid %d or ",$i)}printf("resid %d",$NF)}' )
fi

if [ ! -d molgraphic ]; then
    mkdir molgraphic
fi

cat << EOF > molgraphic/ave_sp=${sparsity}_res${resid}.tcl
mol new {ave.pdb} type {pdb}
axes location off

mol modcolor    0 0 ColorID 0
mol modstyle    0 0 Newcartoon
mol modmaterial 0 0 Transparent

mol addrep 0
mol modselect   1 0 resid ${resid}
mol modcolor    1 0 ColorID 1
mol modstyle    1 0 VDW
mol modmaterial 1 0 Opaque

EOF

i=2

if [ ${N_seqA} -gt 0 ]; then
    cat << EOF >> molgraphic/ave_sp=${sparsity}_res${resid}.tcl
mol addrep 0
mol modselect   ${i} 0 ${seq_A}
mol modcolor    ${i} 0 ColorID 3
mol modstyle    ${i} 0 VDW
mol modmaterial ${i} 0 Opaque

EOF

    i=`expr ${i} + 1`
fi

cat << EOF >> molgraphic/ave_sp=${sparsity}_res${resid}.tcl
set filename molgraphic/ave_sp=${sparsity}_${resid}_open
render Tachyon \$filename
"/Applications/VMD\ 1.9.4.app/Contents/vmd/tachyon_MACOSXX86" \
    -aasamples 12 \$filename -format TARGA -res 1600 1200 \
    -o \$filename.tga

quit
EOF

/Applications/VMD\ 1.9.4.app/Contents/vmd/vmd_MACOSXX86 \
    -e molgraphic/ave_sp=${sparsity}_res${resid}.tcl

cat << EOF > molgraphic/ave_sp=${sparsity}_res${resid}_close.tcl
mol new {ave_close.pdb} type {pdb}
axes location off

mol modcolor    0 0 ColorID 0
mol modstyle    0 0 Newcartoon
mol modmaterial 0 0 Transparent

mol addrep 0
mol modselect   1 0 resid ${id}
mol modcolor    1 0 ColorID 1
mol modstyle    1 0 VDW
mol modmaterial 1 0 Opaque

EOF

i=2

if [ ${N_seqB} -gt 0 ]; then
    cat << EOF >> molgraphic/ave_sp=${sparsity}_res${resid}_close.tcl
mol addrep 0
mol modselect   ${i} 0 ${seq_B}
mol modcolor    ${i} 0 ColorID 3
mol modstyle    ${i} 0 VDW
mol modmaterial ${i} 0 Opaque

EOF

    i=`expr ${i} + 1`
fi

cat << EOF >> molgraphic/ave_sp=${sparsity}_res${resid}_close.tcl
set filename molgraphic/ave_sp=${sparsity}_${resid}_close
render Tachyon \$filename
"/Applications/VMD\ 1.9.4.app/Contents/vmd/tachyon_MACOSXX86" \
    -aasamples 12 \$filename \
    -format TARGA -res 1600 1200 \
    -o \$filename.tga

quit
EOF

/Applications/VMD\ 1.9.4.app/Contents/vmd/vmd_MACOSXX86 \
    -e molgraphic/ave_sp=${sparsity}_res${resid}.tcl


