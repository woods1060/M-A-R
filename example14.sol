pragma solidity ^0.4.18;
// pragma solidity >=0.4.21 <0.7.0;

contract Reentrance {
  event Test(address addr, uint value, uint amount);
  
  // using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    // balances[_to] = balances[_to].add(msg.value);
    balances[_to] = balances[_to] + msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    emit Test(msg.sender, balances[msg.sender], _amount);
    if(balances[msg.sender] >= _amount) {
      if(msg.sender.call.value(_amount)()) {
        _amount;
      } else {
        revert("COULD NOT SEND VALUE!");
      }
      balances[msg.sender] -= _amount;
    }
  }

  function() public payable {}
}
