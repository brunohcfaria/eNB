from ipcqueue import sysvmq 
from optparse import OptionParser
import sys
import os

from enbsim_defs import ENBSIM_QUEUE_ID


def msg_queue(user_dic: dict):
    """
    Send commands to the enbsim daemon

    Parameters
    ----------
    user_dic : dict containing the command
        A dictionary containing the command
    """
    q = sysvmq.Queue(ENBSIM_QUEUE_ID)
    q.put(user_dic)

def main():
    working_dir = os.getcwd()
    dic = {}
    parser = OptionParser()
    parser.add_option("-P", "--procedure", dest="process", help="starting simulator")
    parser.add_option("-I", "--enbip", dest="enb_ip", help="eNB Local IP Address")
    parser.add_option("-M", "--mmeip", dest="mme_ip", help="MME IP Address")
    parser.add_option("-S", "--imsi", dest="imsi", help="IMSI (15 digits)")
    parser.add_option("-K", "--key", dest="ki", help="ki for Milenage (if not using option -u)")  
    parser.add_option("-C", "--opc", dest="opc", help="opc for Milenage (if not using option -u)")  
    parser.add_option("-L", "--mcc", dest="mcc", help="Operator MCC")
    parser.add_option("-N", "--mnc", dest="mnc", help="Operator MNC")
    parser.add_option("-A", "--apn", dest="apn", help="Operator APN")
    parser.add_option("-T", "--tac1", dest="tac1", help="Operator TAC1")
    parser.add_option("-V", "--tac2", dest="tac2", help="Operator TAC2")
    parser.add_option("-E", "--enbid", dest="enb_id", help="Enodeb id")
    parser.add_option("-X", "--enbname", dest="enb_name", help="Enodeb Name")
    parser.add_option("-B", "--attachtype", dest="attach_type", help="Attach Type")
    (options, args) = parser.parse_args()
    if len(sys.argv) <= 1:
        print("No arguments passed - You need to specify parameters to use.")
        parser.print_help()
        exit(1)
    if options.process is not None:
        dic['procedure'] = str(options.process)
    if options.enb_ip is not None:
        dic['enb_ip'] = str(options.enb_ip)
    if options.mme_ip is not None:
        dic['mme_ip'] = str(options.mme_ip)
    if options.imsi is not None:
        dic['imsi'] = str(options.imsi)
    if options.ki is not None:
        dic['ki'] = str(options.ki)
    if options.opc is not None:
        dic['opc'] = str(options.opc)
    if options.mcc is not None:
        dic['mcc'] = str(options.mcc)  
    if options.mnc is not None:
        dic['mnc'] = str(options.mnc)  
    if options.apn is not None:
        dic['apn'] = str(options.apn) 
    if options.tac1 is not None:
        dic['tac1'] = str(options.tac1)
    if options.tac2 is not None:
        dic['tac2'] = str(options.tac2)
    if options.enb_id is not None:
        dic['enb_id'] = str(options.enb_id)
    if options.enb_name is not None:
        dic['enb_name'] = str(options.enb_name)
    if options.attach_type is not None:
        dic['attach_type'] = str(options.attach_type)

    if 'procedure' in dic:
        msg_queue(dic)

if __name__ == "__main__":
    main()
