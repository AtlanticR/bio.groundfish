

#  gs_survey_list
gunzip gs_survey_list.dat.gz
gawk 'BEGIN {RS="\n"; FS=";"; OFS=";"} \
      NF>5 && NR>2 && !/MISSION/ && !/----/ && !/SQL/ && !/select/ \
      {gsub(/[ ]/,""); print $0}'  gs_survey_list.dat > gs_survey_list.out
gzip gs_survey_list.dat


#  gsmission_list
gunzip gsmission_list.dat.gz
gawk 'BEGIN {RS="\n"; FS=";"; OFS=";"} \
      NF>5 && NR>2 && !/MISSION/ && !/----/ && !/SQL/ && !/select/ \
      {gsub(/[ ]/,""); print $0}'  gsmission_list.dat > gsmission_list.out
gzip gsmission_list.dat


# gsmissions
gunzip gsmissions.dat.gz
gawk 'BEGIN {RS="\n"; FS=";"; OFS=";"} \
      NF>2 && NR>2 && !/MISSION/ && !/----/ && !/SQL/ && !/select/ \
      {gsub(/[ ]/,""); print $0}'  gsmissions.dat > gsmissions.out
gzip gsmissions.dat


# gsinf
gunzip gsinf.dat.gz 
gawk 'BEGIN {FS="\n"; OFS=";"}  \
      NR>2 && !/MISSION/ && !/REMARK/ && !/----/ && !/SQL/ && !/select/ \
      {gsub(/[ ]/,""); print $1, $2 } ' gsinf.dat | \
gawk 'BEGIN {RS="\n"; FS=";"; OFS=";"} \
      NF> 10 \
      {print $1, $2, $5, $6, $7, $10, $11, $12, $14, $16, $17, $21, $22 }' > gsinf.out 
gzip gsinf.dat


# gsdet 1268091
gunzip gsdet.dat.gz
gawk 'BEGIN {RS="\n"; FS=";"; OFS=";"} \
      NF>10 && NR>2 && !/MISSION/ && !/----/ && !/SQL/ && !/select/ \
      {gsub(/[ ]/,""); print $1, $2, $3, $4, $5, $6, $7, $8, $9, $13}'  gsdet.dat  > gsdet.out 
gzip gsdet.dat



#  gscat.dat 125988  
gunzip gscat.dat.gz
gawk 'BEGIN {RS="\n"; FS=";"; OFS=";"} \
      NF>5 && NR>2 && !/MISSION/ && !/----/ && !/SQL/ && !/select/ \
      {gsub(/[ ]/,""); print $1, $2, $3, $5, $6, $7, $8}'  gscat.dat > gscat.out
gzip gscat.dat



#  gshyd.dat 537035
gunzip gshyd.dat.gz
gawk 'BEGIN {RS="\n"; FS=";"; OFS=";"} \
      NF>5 && NR>2 && !/MISSION/ && !/----/ && !/SQL/ && !/select/ \
      {gsub(/[ ]/,""); print  $1, $2, $3, $4, $5, $9}'  gshyd.dat > gshyd.out
gzip gshyd.dat



