#!/bin/bash
if [ -a output.txt ]
then
        rm output.txt;
fi

while read file; do
        curl -sL -w "%{http_code} %{url_effective}\\n" "$file" -o /dev/null >> output.txt;
        sed -i '/^\(1\|2\|3\)/d' output.txt;
        if [ -s output.txt ]
        then
                
                if [ $1 ]
                then
                        mail -s "Sites Down" $1 < ./output.txt;
                else
                        if [ -s email_list.txt ]
			then
                        	while read file; do
                        	        mail -s "Sites Down" $file < ./output.txt;
                        	done < ./email_list.txt
                        else
                                :
                        fi    
                fi
        fi
done < ./sites.txt;
rm ./output.txt
