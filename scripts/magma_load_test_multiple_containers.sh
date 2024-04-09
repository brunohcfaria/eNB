#!/bin/bash

# Start multiple containers where each one run an eNB simulator instance
#NUM_CONTAINERS=2
S1AP_PORT=36412
EXPOSED_PORT_BASE=36000 #at least 100 ports available from IANA table...
#MME_IP=192.168.130.2
IMSI_BATCH=10

MME_IPS=(10.250.210.179 10.250.210.180 10.250.210.181 10.250.210.182 10.250.210.183 10.250.210.184 10.250.210.185 10.250.210.186 10.250.210.187 10.250.210.188 10.250.210.189 10.250.210.190 10.250.210.191 10.250.210.192 10.250.210.193 10.250.210.194 10.250.210.195 10.250.210.196 10.250.210.197 10.250.210.200)
NUM_CONTAINERS=${#MME_IPS[@]}

run_load_test()
{
    echo "######  Running load test!"
    for i in $(seq $NUM_CONTAINERS)
    do
        CONTAINER_NAME=enbsim-$i
        ENB_ID=$(( 100000 + $i - 1))
        echo "Sending S1APSetupRequest from simulation instance $CONTAINER_NAME - eNBId=$ENB_ID"
        # docker exec -it $CONTAINER_NAME python3 enbsim_cli.py -P s1-setup --enb_name $CONTAINER_NAME --mcc 001 --mnc 01 --enbid 100000 --tac1 1

        FROM_REQ=$(( ($i-1)*$IMSI_BATCH ))
        TO_REQ=$(( ($i)*$IMSI_BATCH-1 ))
        for j in $(seq -f "%04g" $FROM_REQ $TO_REQ)
        do
            IMSI=00101000000$j
            echo "Sending attach request with imsi $IMSI"
            # docker exec -it enbsim python3 enbsim_cli.py -P attach --imsi $IMSI --key 000102030405060708090A0B0C0D0E0F --opc 24c05f7c2f2b368de10f252f25f6cfc2
            docker exec -it $CONTAINER_NAME python3 enbsim_cli.py -P attach --imsi $IMSI --key 00112233445566778899aabbccddee --opc 63bfa50ee6523365ff14c1f45f88737d
            sleep 0.2
        done
    done
}


# Create the simulation network
# docker network create --subnet=172.18.0.0/16 enbsim-net

for i in $(seq $NUM_CONTAINERS)
do
    CONTAINER_NAME=enbsim-$i
    EXPOSED_PORT=$(($EXPOSED_PORT_BASE+12+$i))
    CONTAINER_ADDRESS=172.18.0.$((12+$i))
    echo "Creating container $CONTAINER_NAME: enb_ip=$CONTAINER_ADDRESS port=$EXPOSED_PORT mme_ip=${MME_IPS[(($i-1))]}"
    #(cd ../ && docker run --name $CONTAINER_NAME -v .:/usr/src/eNB --cap-add NET_ADMIN -p $EXPOSED_PORT:36412 --net enbsim-net --ip $CONTAINER_ADDRESS  -d enbsim --enb_ip $CONTAINER_ADDRESS --mme_ip $MME_IP)
    sleep 0.2
done
run_load_test