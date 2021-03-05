pragma solidity ^0.4.21;

contract PrivateBank
{
    mapping (address => uint) public balances; 
    
    
    function deposit()
    public
    payable
    {

            balances[msg.sender]+=msg.value;

    }
    
    function CashOut(uint _am)
    {
        if(_am<=balances[msg.sender])
        {            
            // <yes> <report> REENTRANCY
            if(msg.sender.call.value(_am)())
            {
                balances[msg.sender]-=_am;
            }
        }
    }    
}