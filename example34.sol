pragma solidity ^0.4.19;

contract PIGGY_BANK
{
    mapping (address => uint) public Accounts;
    
    uint public MinSum = 1 ether;
    
    
    uint putBlock;
    
    
    function Put(address to)
    public
    payable
    {
        Accounts[to]+=msg.value;

    }
    
    function Collect(uint _am) public payable {
        if(Accounts[msg.sender]>=MinSum && _am<=Accounts[msg.sender] && block.number>putBlock) {
            if(msg.sender.call.value(_am)()) {
                Accounts[msg.sender]-=_am;
            }
        }
    }
    
    function() 
    public 
    payable
    {
        Put(msg.sender);
    }    
    
}
