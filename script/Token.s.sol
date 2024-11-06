// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Token, Token2} from "../src/test/Token.sol";

contract TokenScript is Script {
    Token token;
    Token2 token2;

    function run() public {
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

        token = new Token(1);
        token2 = new Token2(true);

        vm.stopBroadcast();
    }
}
