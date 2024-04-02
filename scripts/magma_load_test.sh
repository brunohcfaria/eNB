#!/bin/sh

# Load test the MME by sending MAX_REQ attach requests.

ENB_S1AP_IP="192.168.130.10"
MME_S1AP_IP="192.168.130.2"
MAX_REQ=10

# for i in $(seq $MAX_REQ)
for i in $(seq -f "%04g" $MAX_REQ)
do
    IMSI=00101000000$i
    echo "Sending attach request to imsi $IMSI"
    docker exec -it enbsim python3 enbsim_cli.py -P attach --imsi $IMSI --key 000102030405060708090A0B0C0D0E0F --opc 24c05f7c2f2b368de10f252f25f6cfc2
done
