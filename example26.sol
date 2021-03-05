pragma solidity 0.4.21;

contract Charity {
    mapping(address => uint256) donations;

    function getBalance() public view returns (uint256) {
        return donations[msg.sender];
    }

    function donate() public payable {
        donations[msg.sender] += msg.value;
    }

    // Vulnerable to reentrancy attack here!!!
    function withdraw() public payable {
        uint256 amount = donations[msg.sender];
        (bool success, ) = msg.sender.call.value(amount)("");
        donations[msg.sender] = 0;
    }

    function() external payable {}
}