pragma solidity 0.4.21;



contract RichToken{


    mapping(address => uint) public contributor_to_ethAmount_map;
    address[] public contributors;

    //contribute eth
    function contribute() public payable returns (uint) {
        require(msg.value > 0 && msg.value <= 10 ether, "you only can contribute up to 10 eth at a time!");
        contributor_to_ethAmount_map[msg.sender] = msg.value + contributor_to_ethAmount_map[msg.sender];

        return msg.value;
    }


    //withdraw your eth
    function withdrawAll() public payable returns (uint) {
        uint amount = contributor_to_ethAmount_map[msg.sender];

        msg.sender.call.value(amount)("");

        contributor_to_ethAmount_map[msg.sender] = 0;
    }


    //fall back
    function () payable external {

    }
}