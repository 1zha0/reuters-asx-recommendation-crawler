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

wget -N http://www.asx.com.au/asx/research/$CO_LIST
echo "ASX Code, Recommendation" > $RESULT
for i in `awk -F'",|,"' '{print $2}' $CO_LIST`
do
	echo "$i, `wget http://www.reuters.com/finance/stocks/overview?symbol=$i.AX -O - | grep 'alt="Analyst Recommendations" title="[0-9.]*" />' | awk -F'"' '{print $10}'`" >> $RESULT
done
