pragma solidity ^0.4.21;

contract Investitions {
    mapping (address => uint256) investors;

    function refund() public {
        msg.sender.call.value(investors[msg.sender])();
        investors[msg.sender] = 0;
    }

    function sendMoney() payable public {
        investors[msg.sender] += msg.value;
    }

    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
}