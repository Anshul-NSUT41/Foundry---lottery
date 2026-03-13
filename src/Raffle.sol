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

import {
    VRFConsumerBaseV2Plus
} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {
    VRFV2PlusClient
} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/* * @title Raffle
 * @author Anshul
 * @notice Creating a simple raffle
 * @dev implements chainlink vrf v2.5
 */

contract Raffle is VRFConsumerBaseV2Plus {
    /** errors */
    error Raffle_SendMoreToEnterRaffle();
    error TimeDiffLessThanInterval();

    /** State variables */
    uint16 private constant REQUEST_CONFIRMATIONS = 3;   
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    // @dev The duration of lottery in seconds
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyHash;
    uint32 private immutable i_callbackGasLimit ;
    uint256 private immutable i_subscriptionId;
    uint256 private s_lastTimeStamp;
    uint32 private constant NUM_WORDS = 1;
    

    /**events */
    event RaffleEntered(address indexed player);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane ,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    /**functions */
    function enterRaffle() public payable {
        // require(msg.value >= i_entranceFee , "Not enough eth sent");
        // require(msg.value >= i_entranceFee , SendMoreToEnterraffle());
        // to be gas efficient use if
        if (msg.value < i_entranceFee) {
            revert Raffle_SendMoreToEnterRaffle();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }

    function pickWinner() external  {
        if ((block.timestamp - s_lastTimeStamp) > i_interval) {
            revert TimeDiffLessThanInterval();
        }
        
        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient
            .RandomWordsRequest({
                keyHash: i_keyHash,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            });
      uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
    }

    /** Getter functions */
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function fulfillRandomWords(
    uint256 requestId,
    uint256[] calldata randomWords
) internal override {
}
}
