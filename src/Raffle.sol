// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions


//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Raffle
 * @author Anshul
 * @notice Creating a simple raffle
 * @dev implements chainlink vrf v2.5
 */

contract Raffle {
    /** errors */
    error Raffle_SendMoreToEnterRaffle();

    /** State variables */
    uint256 private immutable i_entranceFee;
    address payable[] private s_players ; // whoever wins gets lottery that's why payable
    
    /**events */
    event RaffleEntered(address indexed player) ;
    constructor (uint256 entranceFee){
        i_entranceFee = entranceFee ;
    }

    /**functions */
    function enterRaffle() public payable {
       // require(msg.value >= i_entranceFee , "Not enough eth sent");
       // require(msg.value >= i_entranceFee , SendMoreToEnterraffle());
       // to be gas efficient use if 
       if(msg.value < i_entranceFee){
        revert Raffle_SendMoreToEnterRaffle();
       }
       s_players.push(payable(msg.sender));
       emit RaffleEntered(msg.sender);
    }

    function pickWinner() public {}

    /** Getter functions */
    function getEntranceFee() public view returns(uint256){
        return i_entranceFee ;
    }
}