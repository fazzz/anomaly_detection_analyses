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

n_s=${#sparsity[*]}

fig=${fig}_rivise-version

if [ ! -d ${fig} ]; then
    mkdir ${fig}
fi

cd ${fig}

#mkdir tmp_Fig1_rv

if [ -f tmp01 ]; then
    rm tmp01
fi

if [ -f tmp02 ]; then
    rm tmp02
fi

n_pairs=$( wc -l ../${dist}/${pairs} | awk '{print $1}' )

numres_1=`expr ${numres} - 1`
n=`expr ${numres} \* ${numres_1}`
n=`expr ${n} / 2`

j=1
lw=1.0
color=$( echo "scale=4.0;(1.0/${n_s})" | bc )
for s in ${sparsity[*]}; do
    i=1
#    p2g ../${anomaly}/a_d_r-r_sp=${s}_ss_A_res-res_pairs.txt \
#	../${anomaly}/a_d_r-r_sp=${s}_ss_A_res-res_graph.txt ${numres}

    cat ../${anomaly}/a_d_r-r_sp=${s}_ss_A_res-res_graph.txt | while read line; do
	if [ ! -f tmp_Fig1_rv/${i}-${s}_A ]; then
	    echo ${line} | awk '{printf("%4d\n%4d\n", $1, $2)}' > tmp_Fig1_rv/${i}-${s}_A
	fi
	
	cat <<EOF >> tmp01
"tmp_Fig1_rv/${i}-${s}_A" u (cos(2.0*pi*(\$1/${n}))):(sin(2.0*pi*(\$1/${n}))):(${color}) \\
w p pt 7 ps 1.0 lc palette notitle, \\
"tmp_Fig1_rv/${i}-${s}_A" u (cos(2.0*pi*(\$1/${n}))):(sin(2.0*pi*(\$1/${n}))):(${color}) \\
w l lw ${lw} lc palette notitle, \\
EOF
	i=`expr ${i} + 1`
    done
    j=`expr ${j} + 1`
    lw=$( echo "scale=2.0;${lw} + 0.2" | bc )
    color=$( echo "scale=4.0;${color} + (1.0/${n_s})" | bc )
done

j=1
lw=1.0
color=$( echo "scale=2.0;(1.0/${n_s})+2.0" | bc )
for s in ${sparsity[*]}; do
    i=1
#    p2g ../${anomaly}/a_d_r-r_sp=${s}_ss_B_res-res_pairs.txt \
#	../${anomaly}/a_d_r-r_sp=${s}_ss_B_res-res_graph.txt ${numres}

    cat ../${anomaly}/a_d_r-r_sp=${s}_ss_B_res-res_graph.txt | while read line; do
	if [ ! -f tmp_Fig1_rv/${i}-${s}_B ]; then
	    echo ${line} | awk '{printf("%4d\n%4d\n", $1, $2)}' > tmp_Fig1_rv/${i}-${s}_B
	fi

	cat <<EOF >> tmp02
"tmp_Fig1_rv/${i}-${s}_B" u (1.025*cos(2.0*pi*(\$1/${n}))):(1.025*sin(2.0*pi*(\$1/${n}))):(${color}) \\
w p pt 7 ps 1.0 lc palette notitle, \\
"tmp_Fig1_rv/${i}-${s}_B" u (1.025*cos(2.0*pi*(\$1/${n}))):(1.025*sin(2.0*pi*(\$1/${n}))):(${color}) \\
w l lw ${lw} lc palette notitle, \\
EOF
	i=`expr ${i} + 1`
    done
    j=`expr ${j} + 1`
    lw=$( echo "scale=2.0;${lw} + 0.2" | bc )
    color=$( echo "scale=2.0;${color} + (1.0/${n_s})" | bc )
done

# colorbar
if [ ! -f colorbar.txt ]; then
    for s in 1 2 ; do
	for i in `seq 1 ${numres}`; do 
	    resindex=`expr $i + $nc`
	    printf "%4d %4d %4d\n" $s $resindex $i
	done
    done > colorbar.txt
fi

cat <<EOF > ss-network_of-cov_d_r-r.gp
#!/usr/local/bin/gnuplot

#set terminal postscript eps enhanced background rgb 'white' color size 10cm , 12cm  "Times" 20
set terminal postscript eps enhanced background rgb 'white' color size 15cm , 18cm  "Times" 22
set output "ss-network_of-cov_d_r-r.eps"

set encoding iso_8859_1

set tics out

set size square

set tics   font "Times-Roman,20"
set cbtics   font "Times-Roman,9"
set xlabel font "Times-Roman,24"
set ylabel font "Times-Roman,24"
set label  font "Times-Roman,24"
set cblabel font "Times-Roman,10"
set key    font "Times-Roman,20"

set noborder

set multiplot layout 2,1

set key right bottom

set noxlabel
set noylabel

set noxzeroaxis
set noyzeroaxis

unset xtics
unset ytics

set palette defined (0 "pink", \\
                     1 "red", \\
                     2 "light-blue", \\
                     3 "blue", \\
                     4 '#D73027',\\
    	    	     5 '#F46D43',\\
		     6 '#FDAE61',\\
		     7 '#FEE08B',\\
		     8 '#D9EF8B',\\
		     9 '#A6D96A',\\
		    10 '#66BD63',\\
		    11 '#1A9850' )

unset colorbox

set xrange [-1.2:1.2]
set yrange [-1.2:1.2]

set rmargin screen 0.90
set lmargin screen 0.10
set tmargin screen 0.90
set bmargin screen 0.30

plot \\
EOF

cat tmp01 >> ss-network_of-cov_d_r-r.gp
cat tmp02 >> ss-network_of-cov_d_r-r.gp

i=1
i_o=1
while [ $i -le ${numres} ]; do
    m_i=`expr ${i_o} \* ${m}`

    j=`expr ${i} + 1`
    j_o=1
    while [ $j -le ${numres} ]; do
	ii=${i}

	m_j=`expr ${j_o} \* ${m}`

	while [ $ii -le ${m_i} -a $ii -le ${numres} ]; do
	    jj=`expr ${m_j} - ${m}`
	    jj=`expr ${jj} + 1`
	    if [ ${jj} -le ${ii}  ]; then
		jj=`expr ${ii} + 1`
	    fi

	    while [ $jj -le ${m_j} -a $jj -le ${numres} ]; do
		printf "%5d %5d\n"  ${ii} ${jj}
		jj=`expr ${jj} + 1`
	    done
	    ii=`expr ${ii} + 1`
	done
	j=`expr ${m_j} + 1`
	j_o=`expr ${j_o} + 1`
    done
    i=`expr ${m_i} + 1`
    i_o=`expr ${i_o} + 1`
done > tmp03

cat <<EOF >> ss-network_of-cov_d_r-r.gp
"tmp03" u (1.1*cos(2.0*pi*(\$0/${n}))):(1.1*sin(2.0*pi*(\$0/${n}))):(\$1/${numres}*7+4) w l lw 20.0 lc palette notitle, \\
"tmp03" u (1.150*cos(2.0*pi*(\$0/${n}))):(1.150*sin(2.0*pi*(\$0/${n}))):(\$2/${numres}*7+4) w l lw 20.0 lc palette notitle

set palette defined (0 '#D73027',\\
    	    	     1 '#F46D43',\\
		     2 '#FDAE61',\\
		     3 '#FEE08B',\\
		     4 '#D9EF8B',\\
		     5 '#A6D96A',\\
		     6 '#66BD63',\\
		     7 '#1A9850' )

set xrange [${min}:${max}]
set yrange [1:2]

set xtics font "Times-Roman,10"
set xtics ${tics_min},${tics},${tics_max}

set size ratio 0.1
set xlabel "Index of Residue" font "Times-Roman,14" offset 0.0, 0.5

set rmargin screen 0.95
set lmargin screen 0.12
set tmargin screen 0.25
set bmargin screen 0.22

plot 'colorbar.txt' u 2:1:(\$3/${numres}*8) w image notitle

quit
EOF
gnuplot ss-network_of-cov_d_r-r.gp

#rm -r tmp
rm tmp01
rm tmp02

