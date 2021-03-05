from manticore.ethereum import ManticoreEVM,ABI
from manticore.core.smtlib import Operators, solver
import time
import sys
################ Script #######################
def main(argv):
    start = time.time()
    m = ManticoreEVM()
    m.verbosity(0)
# The contract account to analyze
    vulcontract = sys.argv[1]
    with open(vulcontract) as f:
        contract_source_code = f.read()
    with open('exploit-contract.sol') as f:
        exploit_source_code = f.read()

    bug_find = False

# Initialize user and contracts
    user_account = m.create_account(balance=100000000000000000)
    attacker_account = m.create_account(balance=100000000000000000)
    contract_account = m.solidity_create_contract(contract_source_code, owner=user_account)  # Not payable
    exploit_account = m.solidity_create_contract(exploit_source_code, owner=attacker_account)



    print("[+] user deposited some.")

    print("[+] Initial world state")

    print("[+] Set up the exploit")
    exploit_account.set_vulnerable_contract(contract_account)
    
    print("\t Setting 2 reply reps")
    exploit_account.set_reentry_reps(3)

    print("\t Setting reply string")
    d = m.make_symbolic_buffer(8);
    exploit_account.set_reentry_attack_string(d)
    for i in m.all_states:
        i.platform.set_balance(contract_account, 100000000000000000) 

    print("[+] Attacker first transaction")

    exploit_account.proxycall(m.make_symbolic_buffer(4), value=100000000000000000)

    print("[+] Attacker second transaction")
    exploit_account.proxycall(d)

    print("[+] The attacker destroys the exploit contract and profit")
    exploit_account.get_money()

    for state in m.terminated_states:
    # exploit_account.get_money()
        balance_attack = state.platform.get_balance(attacker_account)
        balance_contract = state.platform.get_balance(contract_account)

    #state.constrain(balance_attack > 100000000000000000)
    #state.constrain(balance_contract < 100000000000000000)
        state.constrain(Operators.UGT(balance_attack, balance_contract))
    #balance_attack = state.solve_one(balance_attack)
    #balance_contract = state.solve_one(balance_contract)
        if state.is_feasible():
        # m.generate_testcase(state, 'Bug')
        # m.finalize()
        # print("Bug found! see {}".format(m.workspace))
            m.generate_testcase(state, 'Bug')
        #print(balance_attack)
        #print(balance_contract)
            print("Bug found! see {}".format(m.workspace))
            bug_find = True;
            end = time.time()
            ttime = end-start
            print(ttime)
            print(vulcontract)
            break
        #m.finalize()

    if not bug_find:
        print("no bug found!")
        end = time.time()
        ttime = end-start
        print(ttime)
    filename = 'test_result.txt'
    with open(filename, 'a') as file_object:
        file_object.write(vulcontract + '   ' )
        file_object.write(str(bug_find) + '   ' + str(ttime) + "\n" )
        #file_object.write("\n")

if __name__ == '__main__':
  main(sys.argv)
