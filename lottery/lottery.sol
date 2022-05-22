//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract Lottery {
    
    address payable[] public players;
    address public admin;
    

    constructor() {
        admin = msg.sender;
        players.push(payable(admin));
    }
    
    modifier onlyOwner() {
        require(admin == msg.sender, "You are not the owner");
        _;
    }
    

    receive() external payable {
        require(msg.value == 0.1 ether , "Send 0.1 ether");
        require(msg.sender != admin);
        players.push(payable(msg.sender));
    }
    

    function getBalance() public view onlyOwner returns(uint){
        return address(this).balance;
    }
    
    function random() internal view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    function pickWinner() public onlyOwner {
 
        require(players.length >= 3 , "Not enough players in the lottery");
        
        address payable winner;
        winner = players[random() % players.length];
        
        winner.transfer( (getBalance() * 90) / 100);
        payable(admin).transfer( (getBalance() * 10) / 100);
        
       resetLottery(); 
        
    }
    
    function resetLottery() internal {
        players = new address payable[](0);
    }

}