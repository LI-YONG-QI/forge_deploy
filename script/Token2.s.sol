// // SPDX-License-Identifier: SEE LICENSE IN LICENSE
// pragma solidity ^0.8.20;

// import {Script, console} from "forge-std/Script.sol";
// import {Token, Token2} from "../src/test/Token.sol";
// import {Broadcast} from "../src/Broadcast.sol";

// contract TokenScript is Script {
//     Token2 token2;

//     uint256 privateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80; // Default pk in anvil

//     function run() public {
//         vm.startBroadcast(privateKey);

//         address token = Broadcast.getContract("Token.s.sol", "Token");
//         token2 = new Token2(Token(token));

//         console.log("Token address: ", token);
//         console.log("Token2 address: ", address(token2));

//         vm.stopBroadcast();
//     }
// }
