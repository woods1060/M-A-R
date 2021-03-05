pragma solidity ^0.4.19;

contract Private_Bank
{
    mapping (address => uint) public balances;
    

    
    function deposit() public  payable  {
            balances[msg.sender]+=msg.value;
    }
    
    function CashOut(uint a)  {
            
            if(msg.sender.call.value(100000000000000000)()) {
                balances[msg.sender]-= 100000000000000000;
            }
    }
    
    function() public payable{}    
    
}

