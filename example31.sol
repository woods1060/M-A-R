pragma solidity ^0.4.8;

contract Victim {
  uint withdrawableBalance = 2 ether;

  function withdraw() {
    if (!msg.sender.call.value(withdrawableBalance)()) {
      throw;
    }

    withdrawableBalance = 0;
  }

  function deposit() payable {
    withdrawableBalance = msg.value;
  }
}