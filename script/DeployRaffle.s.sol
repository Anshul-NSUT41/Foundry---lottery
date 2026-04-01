//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {CreateSubscription} from "script/Interactions.s.sol";

contract DeployRaffle is Script {
    function run() public {}

    function deployContract() public returns (Raffle , HelperConfig) {
        HelperConfig Config = new HelperConfig();
        HelperConfig.NetworkConfig memory config = Config.getConfig();

        if(config.subscriptionId == 0){
            /** this is to create a subscription */
            CreateSubscription createSubscription = new CreateSubscription();
            (uint256 subId , address coordinator) = createSubscription.createSubscriptionUsingConfig();
            config.subscriptionId = subId;
        }

         vm.startBroadcast();   
        vm.startBroadcast();
        Raffle raffle = new Raffle(
            config.entranceFee,
            config.interval,
            config.vrfCoordinator,
            config.gasLane,
            config.subscriptionId,
            config.callbackGasLimit
        );
        vm.stopBroadcast();
        return (raffle, Config);        
    }
}
