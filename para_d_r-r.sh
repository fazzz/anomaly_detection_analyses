#!/bin/sh

#sparsity=( 0.50 0.60 0.70 0.80 )
#sparsity=( 0.85 )
sparsity=( 0.80 0.85 )

anomaly=anomaly_d_r-r
dist=dist_r-r

pairs=r-r_pairs_union-open-close.txt
distances=r-r_pairs_union-open-close.txt

fig=fig_d_r-r

min=1
max=164

numres=`expr ${max} - ${min}`
numres=`expr ${numres} + 1`

tics_min=10
tics=20
tics_max=160

A=open
B=close

nc=0

m=10

mol=mol_graphics
tcl_name=nst-ave-anomaly-d_r-r

analyses_A=analyses_1
analyses_B=analyses_1

pca=fig_d_r-r_pca
