CURRENTWD=$(pwd)

if [[ ! -d "$HOME/.tmp/" ]]; then
  mkdir "$HOME/.tmp"
  TEMPDIR="$HOME/.tmp"
fi

wget --save-cookies $TEMPDIR/cookies.txt --keep-session-cookies --post-data="username=adambware&password=ALbware23&login=Log+In" "https://www.iblocklist.com/functions/login.php"

rm $CURRENTWD/login.php

curl -s -b $TEMPDIR/cookies.txt https://www.iblocklist.com/lists.php \
| grep -A 3 'Anti-Infringement\|Spammers\|Malicious\|level1\|ads\|spyware\|badpeers\|spider\|hijacked\|dshield\|webexploit\|Threats\|Hijacked\|Malicious' \
| sed -n "s/.*value='\(http:.*\)'.*/\1/p" \
| xargs curl -L \
| gunzip \
| egrep -v '^#' > ~/Library/Application\ Support/Transmission/blocklists/generated.txt.bin
