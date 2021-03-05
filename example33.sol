pragma solidity ^0.4.21;

contract Bank{
    mapping (address => uint256) public balances;
    function wallet() constant returns(uint256 result){
        return this.balance;
    }
    function recharge() payable{
        balances[msg.sender]+=msg.value;
    }
    function withdraw(){
        require(msg.sender.call.value(balances[msg.sender])());
        balances[msg.sender]=0;
    }
}

