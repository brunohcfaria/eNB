#!/bin/sh

# Load test the MME by sending MAX_REQ attach requests.

run_load_test() 
{
    # for i in $(seq $MAX_REQ)
    for i in $(seq -f "%04g" $MAX_REQ)
    do
        IMSI=00101000000$i
        echo "Sending attach request to imsi $IMSI"
        docker exec -it enbsim python3 enbsim_cli.py -P attach --imsi $IMSI --key 000102030405060708090A0B0C0D0E0F --opc 24c05f7c2f2b368de10f252f25f6cfc2
    done
}

while getopts ":n:" option; do
    case $option in
        n)
            MAX_REQ=$OPTARG
            run_load_test;;
        \?) # Invalid option
            echo "Error: Invalid option"
            exit;;
   esac
done
