// // SPDX-License-Identifier: SEE LICENSE IN LICENSE
// pragma solidity ^0.8.20;

// import {Script, console} from "forge-std/Script.sol";
// import {Token, Token2} from "../src/test/Token.sol";

// contract TokenScript is Script {
//     Token token;
//     Token2 token2;

//     uint256 privateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80; // Default pk in anvil

//     function run() public {
//         vm.startBroadcast(privateKey);

//         token = new Token(1);
//         console.log("Token address: ", address(token));

//         vm.stopBroadcast();
//     }
// }
