pragma solidity ^0.4.21;

contract TokenWithInvariants {
  mapping(address => uint) public balanceOf;
  uint public totalSupply;


  function deposit(uint amount) payable {
    balanceOf[msg.sender] += msg.value;
  }

  function transfer(address to, uint value) {
    if (balanceOf[msg.sender] >= value) {
      balanceOf[to] += value;
      balanceOf[msg.sender] -= value;
    }
  }

  function withdraw()  {
    uint balance = balanceOf[msg.sender];
    if (msg.sender.call.value(balance)()) {
      balanceOf[msg.sender] = 0;
    }
  }
}