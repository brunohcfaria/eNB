# eNB s1 Emulator
# Data throughput performance wont work and iperf udp 1400 mtu  only work 

## Installation

On a Ubuntu systems you can install with:
```
apt-get install -y python3-pip libsctp-dev swig python3-pyscard git net-tools bridge-utils resolvconf
sysctl -w net.ipv4.ip_forward=1
echo "nameserver 8.8.8.8">/etc/resolvconf/resolv.conf.d/head
service resolvconf restart
echo "alias toollog='journalctl -fu tool'">>/root/.bashrc
source /root/.bashrc
```

Finally we will need to install all of the Python packages needed to run the tool.

We can install all these packages using pip3 with:

```
sudo pip3 install -r requirements.txt
```

## Using the container version

Build the image:

`docker build -f Dockerfile -t enbsim:latest .`

Running the simulator:

`docker run --name enbsim -v .:/usr/src/eNB --cap-add NET_ADMIN --network=host enbsim  --enb_ip 192.168.130.10 --mme_ip 192.168.130.2`

To send commands to the simulator process in the container you can use the `docker exec` command

Here's a couple of examples:

- S1AP Setup

`docker exec -it enbsim python3 enbsim_cli.py -P s1-setup --mcc 001 --mnc 01 --enbid 100000 --tac1 1`

- Attach

`docker exec -it enbsim python3 enbsim_cli.py -P attach --imsi 001010000000001 --key 000102030405060708090A0B0C0D0E0F --opc 24c05f7c2f2b368de10f252f25f6cfc2`


## Usage

Many variables needed for SA1P and NAS are defined inside the *session_dict_initialization* function.
You can change them to meet your own needs.

When you call the script these are the options available:

```
#IPV6 IP Command
./simulator.py -P start-simulator --enbip 2001:db8:0:f101::1 --mmeip 2001:db8:0:f101::2    
#IPv4 IP Command
./simulator.py -P start-simulator --enbip 192.168.60.141 --mmeip 192.168.60.144
./simulator.py -P s1-setup s1-setup --mcc 001 --mnc 01 --enbid 100000 --tac1 1 
 (optional parameters for s1-setup "--enbname value")
 
./simulator.py -P s1-reset
./simulator.py -P attach --imsi 001010000000001 --key 000102030405060708090A0B0C0D0E0F --opc 24c05f7c2f2b368de10f252f25f6cfc2
 (optional parameters for attach  "--attachtype imsi or guti ")
 
./simulator.py -P idle --imsi 001010000000001
./simulator.py -P tau --imsi 001010000000001
./simulator.py -P tau-p --imsi 001010000000001
./simulator.py -P tau-combine --imsi 001010000000001
./simulator.py -P service-request --imsi 001010000000001
./simulator.py -P x2 --imsi 001010000000001
./simulator.py -P active-users
./simulator.py -P detach --imsi 001010000000001
./simulator.py -P stop-simulator
  
  ```

Run Data using netns Example for data 
```
ip netns exec 333010000000001 ping 8.8.8.8
```

##
log path :- journalctl -fu tool

shortcut :- toollog


## Docker container

`docker build -f Dockerfile -t enbsim:latest .`
`docker run --name enbsim -v .:/usr/src/eNB --cap-add NET_ADMIN --network=host enbsim  --enb_ip 192.168.130.10 --mme_ip 192.168.130.2`

## Functionality

The application supports currently the following options:

- S1 Setup type: LTE, NB-IoT, or both
- Mobile Identity Type: IMSI or GUTI
- Attach PDN: Default APN, or Specific APN
- Session Type: 4G, 5G or NB-IoT
- Session Sub-Type: No PSM and No eDRX, PSM, eDRX or both PSM and eDRX
- PDN Type ipv4, ipv6, ipv4v6 or Non-IP
- Control Plane Service Request with Radio Bearer or without Radio Bearer
- Attach Type: EPS Attach, Combined EPS/IMSI Attach or Emergency Attach
- TAU Type: TA Updating, Combined TA/LA Updating or Combined TA/LA Updating with IMSI Attach
- Process Paging: Enabled or Disabled
- SMS Update type: Additional Update Type SMS Only: False or True
- eNB Cell and TAC can change
- P-CSCF Restoration Support capability

In terms of procedures, the application supports the following ones:

- S1 Setup Request
- S1 Reset
- Attach
- Detach
- TAU
- TAU Periodic
- Service Request
- UE Context Release
- Send SMS (a predefined one)
- Control Plane Service Request
- E-RAB Modification Indication (5G)
- Secondary RAT Data Usage Report (5G)
- PDN Connectivity
- PDN Disconnect
- Activate/Deactivate GTP-U for Control Plane
- Activate/Deactivate Data over NAS
- Set/Send Non-IP Packet
 


