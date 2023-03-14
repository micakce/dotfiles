tee >(sed '/^\r$/q') >(sed '1,/^\r$/d'| jq '. as $raw | try fromjson catch $raw ') > /dev/null

awk '/^HTTP/{if($2~/2../)print "\033[32m"$0"\033[0m"; else if($2~/3../)print "\033[33m"$0"\033[0m"; else if($2~/4../)print "\033[31m"$0"\033[0m"; else if($2~/5../)print "\033[35m"$0"\033[0m"; else print}'
