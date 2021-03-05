pragma solidity ^0.4.15;

contract Victim {
     // Contract: If the user clears the balance we will pay them 1 eth.
     uint balance = 100;


     // pre: balance > 0

     function withdraw() public {
         require(balance > 0);
         uint transferAmt = 1 ether;
         // Call the sender's fallback function with 1 eth.
         // Note that we fail to specify how much gas is available within ().
         // So, all gas provided by the original caller is available to be consumed.
         // Contracts do not pay any gas fees in the current version of Ethereum.
         // But the contract is paying its own eth to the sender.
         msg.sender.call.value(transferAmt)("");
         // clear the balance
         balance = 0;
     }
     // This contract has some eth provided by a caller
     function() payable external {

     }
}