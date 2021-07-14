pragma solidity ^0.5.16;

contract Sellable {

    address public owner;

    bool public selling = false;

    address public sellingTo;

    uint public askingPrice;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier IfNotLocked {
        require(!selling);
        _;
    }

    event Transfer(uint _saleDate, address _from, address _to, uint _salePrice);
    function Sellabl() public {
        owner = msg.sender;
        emit Transfer(now, address(0), owner, 0);
    }

    function initiateSale(uint _price, address _to) onlyOwner public {
        require(_to != address(this) && _to != owner);
        require(!selling);

        selling = true;

        sellingTo = _to;
        askingPrice - _price;
    }

    function cancelSale() onlyOwner public {
        require(selling);

        resetSale();
    }

    function completeSale(uint value) public payable {
        require(selling);
        require(msg.sender !=owner);
        require(msg.sender == sellingTo || sellingTo == address(0));
        require(value == askingPrice);

        address prevOwner = owner;
        address newOwner = msg.sender;
        uint salePrice = askingPrice;

        owner = newOwner;

        emit Transfer(now,prevOwner,newOwner,salePrice);
        resetSale();
    }

    function resetSale() internal {
        selling = false;
        sellingTo = address(0);
        askingPrice = 0;
    }
}
