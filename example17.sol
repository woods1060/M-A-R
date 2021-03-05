pragma solidity ^0.4.0;

contract DropBox{
    mapping (address => uint) public accounts;

    constructor() public payable {
        drop();
    }

    function drop() public payable {
        accounts[msg.sender] = msg.value;
    }

    function retrieve() public {
        (bool success,) = msg.sender.call.value(accounts[msg.sender])("");
        if (! success ) {
            revert();
        }
        accounts[msg.sender] = 0;
    }

    function() external payable {
        revert();
    }
}