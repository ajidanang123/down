#!/bin/bash
echo "Checking Vps"
curl -o.html https://ifconfig.me
sleep 0.5
clear
apt install jq curl -y
rm /etc/v2ray/domain
rm /var/lib/premium-script/ipvps.conf
DOMAIN=hablestore.me
sub=$(</dev/urandom tr -dc a-z0-9 | head -c4)
SUB_DOMAIN=${sub}.idssh.xyz
CF_ID=Login@Ajivpn.com
CF_KEY=F_4E2bHXMUsiguSaO8GVVhBtlDqW2faVg5LQLHuw
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
echo "Updating DNS for ${SUB_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
echo "Host : $SUB_DOMAIN"
echo $SUB_DOMAIN > /etc/v2ray/domain
echo $SUB_DOMAIN > /var/lib/premium-script/ipvps.conf
rm -f /root/cf.sh
clear
echo -e "BERHASIL MEMBUAT SUBDOMAIN BARU"                                                             
echo "Host : $SUB_DOMAIN"
echo "Harap Update certificate v2ray dengan"
echo "Mengetikkan Perintah certv2ray"
