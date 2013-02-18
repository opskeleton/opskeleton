export ip=`echo $SSH_CONNECTION |  cut -d  ' ' -f 1`
echo $ip
wget -q -O -  "http://$ip:8080/registry/profile/$2"
