#!/bin/sh

for i in `seq -w 001 164`; do
    expect -c "
spawn gmx energy \
    -f eneres_scaled/ener${i}.edr \
    -o eneres_scaled/res${i}.xvg
expect -re \"LJ-14:rest-rest\"
send \" 17 18 21 22 25 26 0\n\"
interact
"
    awk '(($1 !~ /^(\#|\@)/)){printf("%4d %8.3f\n"),$1,$2+$3+0.5*$4+0.5*$5}' \
	eneres_scaled/res${i}.xvg > eneres_scaled/res${i}.txt

    awk '(($1 !~ /^(\#|\@)/)){printf("%4d %8.3f\n"),$1,$2+$3+0.5*$4+0.5*$5+$6+$7}' \
	eneres_scaled/res${i}.xvg > eneres_scaled/res+sol${i}.txt
done

 #  1  Bond             2  Connect-Bonds    3  Angle            4  Proper-Dih. #
 #  5  Improper-Dih.    6  LJ-14            7  Coulomb-14       8  LJ-(SR)     #
 #  9  Coulomb-(SR)    10  Coul.-recip.    11  Potential       12  Box-X       #
 # 13  Box-Y           14  Box-Z           15  Volume          16  Density     #
 # 17  Coul-SR:res-res                     18  LJ-SR:res-res		       #
 # 19  Coul-14:res-res                     20  LJ-14:res-res		       #
 # 21  Coul-SR:res-wores                   22  LJ-SR:res-wores		       #
 # 23  Coul-14:res-wores                   24  LJ-14:res-wores		       #
 # 25  Coul-SR:res-SOL                     26  LJ-SR:res-SOL		       #
 # 27  Coul-14:res-SOL                     28  LJ-14:res-SOL		       #
 # 29  Coul-SR:res-rest                    30  LJ-SR:res-rest		       #
 # 31  Coul-14:res-rest                    32  LJ-14:res-rest		       #
 # 33  Coul-SR:wores-wores                 34  LJ-SR:wores-wores	       #
 # 35  Coul-14:wores-wores                 36  LJ-14:wores-wores	       #
 # 37  Coul-SR:wores-SOL                   38  LJ-SR:wores-SOL		       #
 # 39  Coul-14:wores-SOL                   40  LJ-14:wores-SOL		       #
 # 41  Coul-SR:wores-rest                  42  LJ-SR:wores-rest		       #
 # 43  Coul-14:wores-rest                  44  LJ-14:wores-rest		       #
 # 45  Coul-SR:SOL-SOL                     46  LJ-SR:SOL-SOL		       #
 # 47  Coul-14:SOL-SOL                     48  LJ-14:SOL-SOL		       #
 # 49  Coul-SR:SOL-rest                    50  LJ-SR:SOL-rest		       #
 # 51  Coul-14:SOL-rest                    52  LJ-14:SOL-rest		       #
 # 53  Coul-SR:rest-rest                   54  LJ-SR:rest-rest		       #
 # 55  Coul-14:rest-rest                   56  LJ-14:rest-rest		       #
