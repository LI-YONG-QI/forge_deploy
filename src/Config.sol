// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Vm} from "forge-std/Vm.sol";
import {console} from "forge-std/console.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {Strings} from "./utils/Strings.sol";

library Config {
    using stdJson for *;
    using Strings for *;

    Vm internal constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function deploy(bytes memory bytecode) internal returns (address deployedAddress) {
        require(bytecode.length > 0, "Bytecode cannot be empty");

        assembly {
            // Allocate memory for the bytecode
            let bytecodeStart := add(bytecode, 0x20) // Skip the length prefix
            let bytecodeSize := mload(bytecode) // Read the length of the bytecode

            // Deploy the contract using CREATE
            deployedAddress := create(0, bytecodeStart, bytecodeSize)
        }

        require(deployedAddress != address(0), "Deployment failed");
    }

    /// VIEW FUNCTIONS ///

    function loadConfig(string memory configFile, uint256 chainId, string memory contractName)
        internal
        view
        returns (bytes memory)
    {
        return _getConfig(_buildConfigPath(configFile, chainId), contractName);
    }

    /// PRIVATE FUNCTIONS ///

    function _getConfig(string memory path, string memory contractName) private view returns (bytes memory) {
        string memory configJson = vm.readFile(path);
        return configJson.parseRaw(string.concat(".", contractName));
    }

    function _buildConfigPath(string memory configFile, uint256 chainId) private pure returns (string memory) {
        return string.concat("script/", configFile, "/config/", chainId.toString(), ".json");
    }
}

/// @notice Legacy function
// function deploy(string memory scriptFile, string memory contractName) internal returns (address deployedAddress) {
//     return deploy(scriptFile, contractName, block.chainid);
// }

/// @notice Legacy function
// function deploy(string memory scriptFile, string memory contractName, uint256 chainId)
//     internal
//     returns (address deployedAddress)
// {
//     bytes memory bytecode = vm.getCode(contractName);

//     string memory configPath = buildConfigPath(scriptFile, chainId);
//     //bytes memory args = getConfig(configPath, contractName);

//     //deployedAddress = _deploy(abi.encodePacked(bytecode, parseArgs(args)));
//     vm.label(deployedAddress, contractName);
// }

// function parseArgs(bytes memory data) internal pure returns (bytes memory) {
//     require(data.length > 32, "Data too short");

//     // Skip the first 32 bytes
//     bytes memory result = new bytes(data.length - 32);
//     for (uint256 i = 0; i < result.length; i++) {
//         result[i] = data[i + 32];
//     }

//     return result;
// }

// function process(string memory path, string memory contractName) internal {
//     string memory configJson = vm.readFile(path);
//     string[] memory dynamic = configJson.readStringArray(string.concat(".", contractName, ".dynamic"));

//     for (uint256 i = 0; i < dynamic.length; i++) {
//         string memory keyword = dynamic[i];
//     }
// }
