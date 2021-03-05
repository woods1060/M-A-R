pragma solidity ^0.4.0;

contract DropBoxSafe{
    mapping (address => uint) public accounts;

    constructor() public payable {
        drop();
    }

    function drop() public payable {
        accounts[msg.sender] = msg.value;
    }

    function retrieve() public {
        uint amount = accounts[msg.sender];
        accounts[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

    function() external payable {
        revert();
    }
}