#!/bin/bash

CURL_BIN='/usr/bin/curl' # set path of curl 

###########################################################
# Crontab setup, edit crontab file and add the following:

# 0 8,14 * * * bash /path/to/locationalMarginPrice.sh

# runs locationalMarginPrice.sh at 8 am and 2 pm everyday
###########################################################

unamestring=`uname`
if [ "$unamestring" = 'Darwin' ]; then
    yesterday=`date -v -2d '+%Y%m%d'` # mac discovered
    
elif [ "$unamestring" = 'Linux']; then
    yesterday=`date -d 'yesterday' +'%Y%m%d'` # linux discovered
fi

# curl the url of csv and grep to sort for highest Location Marginal Price
${CURL_BIN} -s "http://www.iso-ne.com/transform/csv/fifteenminutelmp?type=final&start=${yesterday}&end=${yesterday}" |  grep "^\"D\"," | sort -t ',' -n -k"7,7" | tail -n -5 | tail -r | cut -d ',' -f 3,4,5,7

###########################################################
# Email the results:
# Mail Server (MTA) has to be set up, example Postfix
# run following command to mail to list of subscribers

# cat /path/to/locationalMarginPrice.sh | mail -s "Top 5 Locational Margin Price" distributedlist@email.com