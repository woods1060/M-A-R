pragma solidity ^0.4.21;

/**
 * The victim contract explores the vulnerable spot
 */
contract Victim {
  uint balance = 100;

  function withdraw() {
    require (balance > 0);
    uint transferAmt = 1 ether;
    // the attack point
    msg.sender.call.value(transferAmt)();
    // set 0 to prevent user call it again
    balance = 0;
  }

  function() payable{}
}