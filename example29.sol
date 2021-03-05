pragma solidity 0.4.21;

contract VictimContract {
    mapping(address => uint256) public balance;
    uint256 public payableCounter;

    function() external payable {
        balance[msg.sender] += msg.value;
        payableCounter++;
    }

    function withdraw(uint256 amount) public payable {
        require(amount <= balance[msg.sender], "Not enough balance!");
        // BAD!!
        msg.sender.call.value(amount)("");
        balance[msg.sender] -= amount;

        // Better
        // balance[msg.sender] -= amount;
        // msg.sender.call.value(amount)("");
    }
}