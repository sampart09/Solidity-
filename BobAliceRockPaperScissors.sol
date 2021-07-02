pragma solidity ^0.5.0;

contract RockPaperScissors {
    
    address payable private bob;
    address payable private alice;
    string private choiceOfBob;
    string private choiceOfAlice;
    bool private hasBobMadeChoice;
    bool private hasAliceMadeChoice;
    
     
    uint256 public stake; 

    
    mapping(string => mapping(string => uint8)) private states;

    
    constructor() public {
        states['R']['R'] = 0;
        states['R']['P'] = 2;
        states['R']['S'] = 1;
        states['P']['R'] = 1;
        states['P']['P'] = 0;
        states['P']['S'] = 2;
        states['S']['R'] = 2;
        states['S']['P'] = 1;
        states['S']['S'] = 0;

        stake = 1 ether;
    }
    
    
    
    modifier isJoinable() {
        require(bob == address(0) || alice == address(0),
                "The room is full."
        );
        require((bob != address(0) && msg.value == stake) || (bob == address(0)),  
                "You must pay the stake to play the game."
        );
        _;
    }
    
    modifier isPlayer() {
        require(msg.sender == bob || msg.sender == alice,
                "You are not playing this game."
        );
        _;
    }
    
    modifier isValidChoice(string memory _playerChoice) {
        require(keccak256(bytes(_playerChoice)) == keccak256(bytes('R')) ||
                keccak256(bytes(_playerChoice)) == keccak256(bytes('P')) ||
                keccak256(bytes(_playerChoice)) == keccak256(bytes('S')) ,
                "Your choice is not valid, it should be one of R, P and S."
        );
        _;
    }
    
    modifier playersMadeChoice() {
        require(hasPlayer1MadeChoice && hasPlayer2MadeChoice,
                "The player(s) have not made their choice yet."
        );
        _;
    }

     
    function join() external payable 
        
    {
        if (bob == address(0)) {
            bob = msg.sender;
            stake = msg.value; 
            
        } else
            alice = msg.sender;
    }
    
    function makeChoice(string calldata _playerChoice) external 
        isPlayer()                      
        isValidChoice(_playerChoice)     
    {
        if (msg.sender == bob && !hasBobMadeChoice) {
            choiceOfBob = _playerChoice;
            hasBobMadeChoice = true;
        } else if (msg.sender == alice && !hasAliceMadeChoice) {
            choiceOfAlice = _playerChoice;
            hasAliceMadeChoice = true;
        }
    }
    
    function disclose() external 
        isPlayer()          
        playersMadeChoice() 
    {
        
        int result = states[choiceOfBob][choiceOfAlice];
        if (result == 0) {
            bob.transfer(stake); 
            alice.transfer(stake);
        } else if (result == 1) {
            bob.transfer(address(this).balance);
        } else if (result == 2) {
            alice.transfer(address(this).balance);
        }
        
        
        bob = address(0);
        alice = address(0);

        choiceOfBob = "";
        choiceOfAlice = "";
        
        hasBobMadeChoice = false;
        hasAliceMadeChoice = false;
        
        stake = 1 ether;
    }
}
