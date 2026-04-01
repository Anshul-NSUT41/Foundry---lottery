//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script , console} from "forge-std/Script.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.s.sol"; 
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig () public returns (uint256  , address ) {
          HelperConfig helperConfig = new HelperConfig();
          address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
           (uint256 Id , address coordinator) = createSubscription(vrfCoordinator) ;
           return (Id , coordinator);
    }
    function createSubscription(address vrfCoordinator) public returns (uint256 subId , address coordinator) {
        console.log("Cretaing subscription on chain id : " , block.chainid);
        vm.startBroadcast();
        uint256 subId = VRFCoordinatorV2_5Mock(vrfCoordinator).createSubscription();
        vm.stopBroadcast();
        console.log("Your subscription ID is: " , subId);
        console.log( "Please update the subscriptionId in HelperConfig.s.sol and re-run the deployment script" );
        return (subId , vrfCoordinator);
    }
}
