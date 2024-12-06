// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Vm} from "forge-std/Vm.sol";
import {console} from "forge-std/console.sol";
import {stdJson} from "forge-std/StdJson.sol";

library Config {
    using stdJson for *;

    bytes16 private constant HEX_DIGITS = "0123456789abcdef";
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
        return string.concat("script/", configFile, "/config/", _toString(chainId), ".json");
    }

    /// @dev copied from oz String library
    function _toString(uint256 value) private pure returns (string memory) {
        unchecked {
            uint256 length = _log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            assembly ("memory-safe") {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                assembly ("memory-safe") {
                    mstore8(ptr, byte(mod(value, 10), HEX_DIGITS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /// @dev copied from oz String library
    function _log10(uint256 value) private pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
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
