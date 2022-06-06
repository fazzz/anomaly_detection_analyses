#!/bin/sh

opt=( dummy file )
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

name=$( basename ${file} .txt )
n=$( grep -n "The Sparse structure of data set A" ${file} | awk -F':' '{print $1}' )
l=$( grep -n "The Sparse structure of data set B" ${file} | awk -F':' '{print $1}' )
m=$( grep -n "The anomaly of each dimension" ${file} | awk -F':' '{print $1}' )

o=`expr $l - $n`
o=`expr $o + 1`

head -${l} ${file} | tail -${o} > ${name}_ss_A.txt

p=`expr $m - $l`
p=`expr $p + 1`

head -${m} ${file} | tail -${p} > ${name}_ss_B.txt

ll=$( wc -l ${file} | awk '{print $1}' )

q=`expr ${ll} - $m`
q=`expr $q + 1`

tail -${q} ${file} > ${name}_anomaly.txt
