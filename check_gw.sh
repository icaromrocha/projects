#!/bin/bash

PATH=/sbin:/bin:/usr/sbin:/usr/bin

gatewaympls=$(psql -U postgres brcconfig -A -t -c "SELECT (((obj_addr.data->'obj_addr-ip_mask')->>0)::inet) AS obj_addr_ip_mask FROM box_net_device JOIN obj_addr ON box_net_device.gw_addr_id = obj_addr.id WHERE box_net_device.name = 'tun1';")

while : ;
do

        dr=`/usr/sbin/ip route | /usr/bin/grep default`

        if [ "$dr" = "" ] ; then
                logger -t gw-checker "Missing default route.. Lets try to fix it..."
                /usr/bin/systemctl restart sd-wan.service
                /opt/omne/apply/omne-apply-proxy-http -r
                sleep 10
                #double check
                ndr=`/usr/sbin/ip route | /usr/bin/grep default`
                if [ "$ndr" = "" ] ; then
                        /opt/omne/apply/omne-apply-routes
                        /opt/omne/apply/omne-apply-network
                        /opt/omne/apply/omne-apply-proxy-http -r
                        logger -t gw-checker "Double check.. It fix the problem..."
                fi
                sleep 10
                #third check
                ddr=`/usr/sbin/ip route | /usr/bin/grep default`
                if [ "$ddr" = "" ] ; then
                        /usr/sbin/route add default gw $gatewaympls
                        /opt/omne/apply/omne-apply-proxy-http -r
                        /usr/bin/systemctl restart sd-wan.service
                        logger -t gw-checker "Third check.. It fix the problem..."
                fi
        else
                gw=`/usr/sbin/ip route | /usr/bin/grep default`
                logger -t gw-checker "Default gw OK"
                logger -t gw-checker $gw
        fi

        sleep 90
        logger -t gw-checker "Reaplicando a regra da Impressora"
        /opt/omne/apply/omne-apply-security-policy -p 13
        /opt/omne/apply/omne-apply-security-chains
        /opt/omne/apply/omne-apply-proxy-ssl -c
        /opt/omne/apply/omne-apply-auth-ipset-sessions
done
