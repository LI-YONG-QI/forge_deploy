// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Config} from "../src/Config.sol";
import {Map} from "../src/test/Map.sol";
import {Deployer} from "../script/token/Deployer.sol";
import {Token2} from "../src/test/Token2.sol";
import {Token3} from "../src/test/Token3.sol";

contract ConfigTest is Test {
    // function test_loadConfig() external {
    //     address addr = Config.deploy("Map", "token", "Map", 31337);

    //     //console.logBytes(type(Map).creationCode);

    //     Map map = Map(addr);
    //     console.log(map.id());
    //     console.log(map.x());
    //     console.log(map.y());
    // }

    // function test_buildDynamicConfig() external {
    //     string memory path = Config.buildConfigPath("token", 31337);
    //     Config.process(path, "Token2");
    // }

    function test_deployer() external {
        address token = address(1);
        address addr = Deployer.deployToken2(token);
        console.log(addr);

        Token2 token2 = Token2(addr);
        console.log(token2.x());
        console.log(token2.y());
        console.log(address(token2.token()));

        address _token3 = Deployer.deployToken3();
        console.log(_token3);

        Token3 token3 = Token3(_token3);
        console.log(token3.a());
        console.log(token3.b());
    }

    // function test_getConfig() external {
    //     string memory data = Config.getConfig("script/token/config/31337.json", "Token2");
    //     console.log(data);
    // }

    // function test_yul() external {
    //     bytes memory data = abi.encode(10, 1);

    //     console.logBytes(data);

    //     console.logBytes(Config.bytesYul(data));

    //     // string memory config = Config.load("token", 31337);
    //     // console.log("Contract address: ", config.length);
    //     // console.log("Contract address: ", config[0]);
    //     // console.log("Contract address: ", config[1]);
    // }

    // function test_GetContractChainId() external {
    //     address contractAddress = Broadcast.getContract("Token.s.sol", "Token", 17000, "run-1730855487");
    //     assertEq(contractAddress, address(0x8d375dE3D5DDde8d8caAaD6a4c31bD291756180b));
    // }

    // function test_exportFile() external {
    //     Broadcast.exportDeployments("deployments/test/", "Token.s.sol", 17000);
    //     Broadcast.exportDeployments("deployments/test/", "Token.s.sol", 31337);
    // }
}
