pragma solidity ^0.4.21;

contract Bank {
   mapping (address=>uint) balances;

	function deposit() public payable {
	   balances[msg.sender] += msg.value;
	}

	function withdraw(uint amount) public {
	   if(balances[msg.sender] >= amount) {
	       // send value using low-level call 
	       // if the sender has enough balance
	      msg.sender.call.value(amount)(abi.encode(""));
	      balances[msg.sender] -= amount;
	   }
	   else {
	       // revert otherwise
	       revert();
	   }
	}

	function balance() public view returns(uint) {
	   return balances[msg.sender];
	 }
	 
	function getTotalBalance() public view returns (uint) {
	    return address(this).balance;
	}
}