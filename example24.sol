pragma solidity ^0.4.21;

/*
Authors: Daniel Hwang, Howey Ho
Assignment 2
*/

contract Dao {

  address private owner;
  uint totalBalance = 0;
  mapping (address => uint) balances;
  //keep a list of every account that made a deposit for ease of resetting mapping.
  address[] accounts;
  uint valuation = 1;
  address curator;

  struct Proposal{
    uint yesVotes;
    uint noVotes;
    uint requiredVotes;
    bool isSealed;
    bool isDone;
    address[] yesVoters;
    address[] noVoters;
  }

  Proposal currentProposal;

  constructor() public {
    owner = msg.sender;
    curator = msg.sender;
  }

  function delegateCurator(address _newCurator) public returns (bool _bool) {
    require(msg.sender == curator);
    require(!currentProposal.isSealed);
    curator = _newCurator;
    return true;
  }

  function findVoter(address _voter) public view returns (bool _isFound){
    for (uint i = 0; i<currentProposal.yesVoters.length; i++){
      if (_voter == currentProposal.yesVoters[i]){
        return true;
      }
    }
    for (uint i = 0; i<currentProposal.noVoters.length; i++){
      if (_voter == currentProposal.noVoters[i]){
        return true;
      }
    }
    return false;
  }

  function deposit() public payable {
    balances[msg.sender] += msg.value;
    totalBalance += msg.value;
    accounts.push(msg.sender);
    for (uint i = 0; i<currentProposal.yesVoters.length; i++){
      if (msg.sender == currentProposal.yesVoters[i]){
        currentProposal.yesVotes += msg.value;
      }
    }
    for (uint i = 0; i<currentProposal.noVoters.length; i++){
      if (msg.sender == currentProposal.noVoters[i]){
        currentProposal.noVotes += msg.value;
      }
    }
    checkVote();
  }

  function withdraw(uint256 _amount) public returns (bool _bool) {
    require(balances[msg.sender] > _amount);
    require(totalBalance > _amount);
    require(!findVoter(msg.sender) || currentProposal.isDone);
    balances[msg.sender] -= _amount;
    totalBalance -= _amount;
    msg.sender.transfer(_amount/valuation);
    return true;
  }

  function getBalance(address _address) public view returns (uint256 _amount) {
    return balances[_address];
  }

  function createProposal() public returns (bool _bool){
    require(msg.sender == curator);
    require(!currentProposal.isSealed);
    delete currentProposal;
    currentProposal = Proposal({
            yesVotes: 0,
            noVotes: 0,
            requiredVotes: totalBalance/2,
            isSealed: false,
            isDone: false,
            yesVoters: new address[](0),
            noVoters: new address[](0)
        });
    return true;
  }

  function vote(bool _vote) public returns (bool _bool){
    require(!findVoter(msg.sender));
    require(!currentProposal.isSealed);
    if (_vote){
      currentProposal.yesVotes += balances[msg.sender];
      currentProposal.yesVoters.push(msg.sender);
    } else{
      currentProposal.noVotes += balances[msg.sender];
      currentProposal.noVoters.push(msg.sender);
    }
    checkVote();
    return true;
  }

  function checkVote() public {
    if (2*currentProposal.yesVotes > currentProposal.requiredVotes){
      currentProposal.isSealed = true;
      currentProposal.isDone = true;
      uint random = random();
      if (random == 0){
        totalBalance == 0;
        for (uint i = 0; i < accounts.length; i++)
          balances[accounts[i]] = 0;
        delete accounts;
      }
      else{
        valuation *= random;
        valuation /= 10;
      }
    }
    if (2*currentProposal.noVotes + 1 > currentProposal.requiredVotes){
      currentProposal.isSealed = true;
      currentProposal.isDone = true;
    }
  }

  //implements a pseudo random gaussian distribution based on summing multiple uniform r.v.s
  function random() public view returns (uint _totalSum){
    uint totalSum = 61;
    while (totalSum < 60){
      totalSum = uint(blockhash(block.number-1)) % 32;
      totalSum += uint(block.coinbase) % 32;
      totalSum += block.difficulty % 32;
      totalSum += block.timestamp % 32;
      totalSum += gasleft() % 32;
    }
    return (totalSum - 60);
  }

  function setBalanceForTest(uint _amount) public returns (bool _bool){
    balances[msg.sender] += _amount;
    return true;
  }

  function setBalanceForTestOtherAddress(uint _amount, address _address) public returns (bool _bool){
    balances[_address] += _amount;
    return true;
  }
}