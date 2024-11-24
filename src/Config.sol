// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Vm} from "forge-std/Vm.sol";
import {console} from "forge-std/console.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

library Config {
    using stdJson for *;
    using Strings for *;

    Vm internal constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function load(string memory targetFile, uint256 chainId) internal view returns (string memory configJson) {
        string memory configPath = string.concat("script/", targetFile, "/config/", vm.toString(chainId), ".json");
        string memory config = vm.readFile(configPath);

        console.logBytes(vm.parseJson(config));
        console.logBytes(abi.encode(0x01, 0x02));

        //configJson = config.readStringArray("");

        // if (!config.keyExists("broadcasts")) {
        //     return "";
        // }

        // string[] memory broadcasts = config.readStringArray("broadcasts");

        // for (uint256 i = 0; i < broadcasts.length; i++) {
        //     string memory broadcast = broadcasts[i];
        //     uint256 chainId_ = broadcast.readUint("chainId");
        //     string memory time_ = broadcast.readString("time");

        //     if (chainId_ == chainId && time_.equal(time)) {
        //         return broadcast;
        //     }
        // }

        // return "";
    }
}
