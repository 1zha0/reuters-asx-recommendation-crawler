#*********************************************************************
#
# This script pulls newest company list from ASX, and then, retrieves
# recommendation index from Reuters.
#
# Update: Jan 6, 2010, Change wget address and awk command, since 
#                      Reuters has changed its website.
#
# Written by:	Liang
# Date:		25/11/2009
#
#*********************************************************************

#!/bin/bash
CO_LIST='ASXListedCompanies.csv'
RESULT='CompaniesRecommendation.csv'
TEMP='CompaniesTemp.csv'

FORMAT_HEADER='###'

function getrecommend() {
	local recommend=`wget http://www.reuters.com/finance/stocks/overview?symbol=$1.AX -O - | grep 'alt="Analyst Recommendations" title="[0-9.]*" />' | awk -F'"' '{print $10}'`
	echo $recommend
}

wget -N http://www.asx.com.au/asx/research/$CO_LIST

if [ -f "$RESULT" ];
then
	mv $RESULT $TEMP
	echo "`head -n1 $TEMP`, `date +"%d/%m/%Y"`" > $RESULT
	FORMAT="`tail -n1 $TEMP`"
else
	echo "ASX Code, `date +"%d/%m/%Y"`" > $RESULT
	FORMAT="$FORMAT_HEADER"
fi
	
for i in `awk -F'",|,"' '{print $2}' $CO_LIST`
do
	if [ -f "$TEMP" ]; then
		if grep -q $i $TEMP; then
			echo "`cat $TEMP | grep $i`, `getrecommend $i`" >> $RESULT
		else
			echo "`echo "$FORMAT" | sed 's/$FORMAT_HEADER/$i/g'`, `getrecommend $i`" >> $RESULT
		fi
	else
		echo "$i, `getrecommend $i`" >> $RESULT
	fi
done
echo "$FORMAT, " >> $RESULT
rm $CO_LIST $TEMP
