#!/bin/sh

for i in `seq -w 001 164`; do
    expect -c "
spawn gmx energy \
    -f eneres/ener${i}.edr \
    -o eneres/res${i}.xvg
expect -re \"LJ-14:wores-wores\"
send \" 16 17 20 21 0\n\"
interact
"
    awk '(($1 !~ /^(\#|\@)/)){printf("%4d %8.3f\n"),$1,$2+$3+0.5*$4+0.5*$5}' \
	eneres/res${i}.xvg > eneres/res${i}.txt
done

 #  1  Bond             2  Connect-Bonds    3  Angle            4  Proper-Dih. #
 #  5  Improper-Dih.    6  LJ-14            7  Coulomb-14       8  LJ-(SR)     #
 #  9  Coulomb-(SR)    10  Potential       11  Box-X           12  Box-Y       #
 # 13  Box-Z                               14  Volume			       #
 # 15  Density                             16  Coul-SR:res-res		       #
 # 17  LJ-SR:res-res                       18  Coul-14:res-res		       #
 # 19  LJ-14:res-res                       20  Coul-SR:res-wores	       #
 # 21  LJ-SR:res-wores                     22  Coul-14:res-wores	       #
 # 23  LJ-14:res-wores                     24  Coul-SR:wores-wores	       #
 # 25  LJ-SR:wores-wores                   26  Coul-14:wores-wores	       #
 # 27  LJ-14:wores-wores						       #
