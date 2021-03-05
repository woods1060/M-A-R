pragma solidity ^0.4.21;

contract MyAugmented {
    mapping(address => uint) balances;
    mapping(address => bool) winners;
    uint gameReward = 50;

    function deposit() payable{
        balances[msg.sender] += msg.value;
    }

    // function withdrawFunds (uint256 _weiToWithdraw) public {
    //     require(balances[msg.sender] >= _weiToWithdraw);
    //     (bool success,) = msg.sender.call.value(_weiToWithdraw)("");
    //     require(success);
    //     balances[msg.sender] -= _weiToWithdraw;
    // }

    function safeWithdrawFunds(uint256 amount) public {
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        (bool success,) = msg.sender.call.value(amount)("");
        require(success);
    }

    function claimReward() public {
        bool isWinner = winners[msg.sender];
        require(isWinner);
        bool hasMoney = balances[msg.sender] > 5;
        require(hasMoney);

        require(msg.sender.call.value(gameReward)());
        winners[msg.sender] = false;
    }
}