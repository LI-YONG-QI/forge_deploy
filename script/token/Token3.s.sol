// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Token3} from "../../src/test/Token3.sol";
import {Script, console} from "forge-std/Script.sol";
import {Deployer} from "./Deployer.sol";

contract Token3Script is Script {
    function run() external {
        vm.startBroadcast();

        Token3 token3 = Token3(Deployer.deployToken3());
        console.log(token3.a());
        console.log(token3.b());

        vm.stopBroadcast();
    }
}
