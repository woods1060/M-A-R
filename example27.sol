pragma solidity 0.4.21;

contract EtherStore {

  mapping(address => uint256) public balances;

  function depositFunds() public payable {
    balances[msg.sender] += msg.value;
  }

  function withdrawFunds (uint256 _weiToWithdraw) public {
    require(balances[msg.sender] >= _weiToWithdraw, "Insufficient balance before the call");

    require(msg.sender.call.value(_weiToWithdraw)(), "failed to send eth.");

    balances[msg.sender] -= _weiToWithdraw;
  }

}