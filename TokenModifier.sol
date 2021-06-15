pragma solidity ^0.6.0;

contract Owned {
    address owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not allowed");
        _;
    }
}

contract InheritanceModifierExample is Owned {
    
    mapping(address => uint) public tokenBalance;
    
    uint tokenPrice = 1 ether;
    
    constructor() public {
        owner = msg.sender;
        tokenBalance[owner] = 100;
    }
    function createNewToken() public {
        tokenBalance[owner]++;
    }
    
    function burnToken() public {
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
