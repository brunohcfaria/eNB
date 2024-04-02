#!/bin/sh

# Provision a sequence of MAX_USERS users in the magma core.

NUM_USERS=10
print_help ()
{
    echo "Add or delete multiple users with sequence IMSIs from 1 to NUM_USERS."
    echo "Syntax: magma_provision_mulitple_users.sh [-a|-d] NUM_USERS>"
    echo "options:"
    echo "a     Add users to the database with IMSIs from 1 to NUM_USERS"
    echo "d     Delete users to the database with IMSIs from 1 to NUM_USERS"
}

add_users () 
{
    for i in $(seq -f "%04g" $NUM_USERS)
    do
        IMSI=IMSI00101000000$i
        echo "Provisioning user - $IMSI"
        docker exec -it magmad subscriber_cli.py add --lte-auth-key 000102030405060708090A0B0C0D0E0F --lte-auth-opc 24c05f7c2f2b368de10f252f25f6cfc2 $IMSI
        # wait for the user database update
        sleep 1
        docker exec -it magmad subscriber_cli.py update --apn-config internet,9,1,0,0,3000000000,4000000000,0,,,, $IMSI
        sleep 1
    done
    echo "Listing the user database..."
    docker exec -it magmad subscriber_cli.py list
}

del_users () {
    for i in $(seq -f "%04g" $NUM_USERS)
    do
        IMSI=IMSI00101000000$i
        echo "Deleting user - $IMSI"
        docker exec -it magmad subscriber_cli.py delete $IMSI
        # wait for the user database update
        sleep 1
    done
    echo "Listing the user database..."
    docker exec -it magmad subscriber_cli.py list
}

while getopts ":ha:d:" option; do
    case $option in
        h) # display Help
            Help
            exit;;
        a)
            NUM_USERS=$OPTARG
            add_users;;
        d)
            NUM_USERS=$OPTARG
            del_users;;
        \?) # Invalid option
            echo "Error: Invalid option"
            exit;;
   esac
done
