pragma solidity ^0.4.21;

contract Reentrancy {

    mapping(address => uint) public balances;
    uint private totalSupply;

    constructor(uint initialSupply) public payable {
        totalSupply = initialSupply;
        balances[msg.sender] = initialSupply;
    }
    
    function() public payable {}
    
    function transfer(address _to, uint _value) public returns(bool) {
        if (balances[msg.sender] < _value) return false;
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function withdraw() public {
        if(msg.sender.call.value(balances[msg.sender])()) {
            balances[msg.sender] = 0;
        }
    }

    function getBalance() public constant returns(uint) {
        return address(this).balance;
    }
}
