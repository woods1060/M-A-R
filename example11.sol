pragma solidity 0.4.21;

contract Propinas {
  mapping (address => uint) public balanceOf;

  constructor() payable public {
    sendTip(msg.sender);
  }

  function sendTip(address _address) payable public {
    balanceOf[_address] += msg.value;
  }

  function get() public {
    require(balanceOf[msg.sender] > 0, 'Balance is zero');
    (bool success, ) = msg.sender.call.value(balanceOf[msg.sender])("");
    require(success, "Transfer failed.");
    balanceOf[msg.sender] = 0;
  }

  receive() external payable {
    balanceOf[msg.sender] += msg.value;
  }

  function getBalanceOf(address _address) external view returns (uint) {
    return balanceOf[_address];
  }
}