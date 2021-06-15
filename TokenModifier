pragma solidity ^0.6.0;

contract InheritanceModifierExample {
    
    mapping(address => uint) public tokenBalance;
    
    address owner;
    
    uint tokenPrice = 1 ether;
    
    constructor() public {
        owner = msg.sender;
        tokenBalance[owner] = 100;
    }
    
    function createNewToken() public {
        require(msg.sender == owner, "You are not allowed");
        tokenBalance[owner]++;
    }
    
    function burnToken() public {
        require(msg.sender == owner, "You are not allowed");
        tokenBalance[owner]--;
    }
    
    function purchaseToken() public payable {
        require((tokenBalance[owner] * tokenPrice) / msg.value > 0, "not enough Tokens");
        tokenBalance[owner] -= msg.value / tokenPrice;
        tokenBalance[msg.sender] += msg.value / tokenPrice;
    }
    
    function sendToken(address _to,uint _amount) public {
        require(tokenBalance[msg.sender] >= _amount, "Not enough Tokens");
        assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
        assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);
    }
}
