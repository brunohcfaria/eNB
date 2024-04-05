#!/bin/bash

# Load test the MME by sending MAX_REQ attach requests.

run_test() 
{
    if [ "$PROC" == "detach" ]; then
        RAND_IMSI_ARRAY=($(seq -f "%04g" $FROM_REQ $TO_REQ | shuf))
        for i in ${RAND_IMSI_ARRAY[@]}
        do
            IMSI=00101000000$i
            echo "Sending detach request to imsi $IMSI"
            docker exec -it enbsim python3 enbsim_cli.py -P detach --imsi $IMSI
        done

    elif [ "$PROC" == "attach" ]; then

        RAND_IMSI_ARRAY=($(seq -f "%04g" $FROM_REQ $TO_REQ | shuf))
        for i in ${RAND_IMSI_ARRAY[@]}
        do
            IMSI=00101000000$i
            echo "Sending attach request to imsi $IMSI"
            # docker exec -it enbsim python3 enbsim_cli.py -P attach --imsi $IMSI --key 000102030405060708090A0B0C0D0E0F --opc 24c05f7c2f2b368de10f252f25f6cfc2
            docker exec -it enbsim python3 enbsim_cli.py -P attach --imsi $IMSI --key 00112233445566778899aabbccddee --opc 63bfa50ee6523365ff14c1f45f88737d
        done

    elif [ "$PROC" == "idle" ]; then

        RAND_IMSI_ARRAY=($(seq -f "%04g" $FROM_REQ $TO_REQ | shuf))
        for i in ${RAND_IMSI_ARRAY[@]}
        do
            IMSI=00101000000$i
            echo "Moving user to idle state for imsi $IMSI"
            docker exec -it enbsim python3 enbsim_cli.py -P idle --imsi $IMSI
        done

    elif [ "$PROC" == "service-request" ]; then

        RAND_IMSI_ARRAY=($(seq -f "%04g" $FROM_REQ $TO_REQ | shuf))
        for i in ${RAND_IMSI_ARRAY[@]}
        do
            IMSI=00101000000$i
            echo "Sending service request from user with imsi $IMSI"
            docker exec -it enbsim python3 enbsim_cli.py -P service-request --imsi $IMSI
        done
    fi
}

while getopts ":n:s:p:" option; do
    case $option in
        n)
            FROM_REQ=$OPTARG
            ;;
        s)
            TO_REQ=$OPTARG
            ;;
        p)
            PROC=$OPTARG
            ;;
        \?) # Invalid option
            echo "Error: Invalid option"
            exit;;
   esac
done
run_test
