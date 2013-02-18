ip=`who am i | sed -r "s/.*\((.*)\).*/\\1/"`
wget -q -O -  "http://$ip:8080/registry/profile/$2"
