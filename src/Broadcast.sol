// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {Strings} from "./utils/Strings.sol";

library Broadcast {
    using stdJson for *;
    using Strings for *;

    Vm internal constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    error ContractNotFound(string targetFile, string contractName, string timestamp, uint256 chainId);

    struct Contract {
        bytes32 txHash;
        address addr;
        string name;
        address deployer;
        string[] args;
        uint256 chainId;
        uint256 tiemstamp;
    }

    function getContract(string memory targetFile, string memory contractName)
        internal
        view
        returns (Contract memory)
    {
        return getContract(targetFile, contractName, block.chainid, "run-latest");
    }

    function load(string memory targetFile) internal view returns (string memory) {
        return load(targetFile, block.chainid, "run-latest");
    }

    /// @notice Get the contract address by broadcast file
    /// @param targetFile The path of target file to load
    /// @param contractName The name of the contract to get
    /// @param chainId The chain id of the broadcast
    /// @param time The timestamp of the broadcast e.g run-<timestamp>
    function getContract(string memory targetFile, string memory contractName, uint256 chainId, string memory time)
        internal
        view
        returns (Contract memory)
    {
        string memory broadcast = load(targetFile, chainId, time);
        uint256 totalTxs = broadcast.readStringArray(".transactions").length;

        Contract memory _contract = Contract({
            txHash: bytes32(0),
            addr: address(0),
            name: "",
            deployer: address(0),
            args: new string[](0),
            chainId: 0,
            tiemstamp: 0
        });

        for (uint32 i = 0; i < totalTxs; i++) {
            string memory _contractName = broadcast.readString(buildTxsPath(i, "contractName"));
            string memory txType = broadcast.readString(buildTxsPath(i, "transactionType"));

            if (_contractName.equal(contractName) && txType.equal("CREATE")) {
                _contract.addr = broadcast.readAddress(buildTxsPath(i, "contractAddress"));
                _contract.name = _contractName;
                _contract.deployer = broadcast.readAddress(buildTxsPath(i, "transaction.from"));
                _contract.args = broadcast.readStringArray(buildTxsPath(i, "arguments"));
                _contract.txHash = broadcast.readBytes32(buildTxsPath(i, "hash"));
                _contract.chainId = chainId;
                _contract.tiemstamp = broadcast.readUint(".timestamp");

                return _contract;
            }
        }

        revert ContractNotFound(targetFile, contractName, time, chainId);
    }

    function getContracts(string memory targetFile, uint256 chainId, string memory time)
        internal
        view
        returns (Contract[] memory)
    {
        string memory broadcast = load(targetFile, chainId, time);
        uint64 count = getDeployedCount(broadcast);
        Contract[] memory contracts = new Contract[](count);

        uint256 totalTxs = broadcast.readStringArray(".transactions").length;
        uint256 index = 0;
        for (uint32 i = 0; i < totalTxs; i++) {
            string memory txType = broadcast.readString(buildTxsPath(i, "transactionType"));

            if (txType.equal("CREATE")) {
                Contract memory data = Contract({
                    txHash: broadcast.readBytes32(buildTxsPath(i, "hash")),
                    addr: broadcast.readAddress(buildTxsPath(i, "contractAddress")),
                    name: broadcast.readString(buildTxsPath(i, "contractName")),
                    deployer: broadcast.readAddress(buildTxsPath(i, "transaction.from")),
                    args: broadcast.readStringArray(buildTxsPath(i, "arguments")),
                    chainId: chainId,
                    tiemstamp: broadcast.readUint(".timestamp")
                });

                contracts[index] = data;
                index++;
            }
        }

        return contracts;
    }

    function getDeployedCount(string memory broadcast) internal pure returns (uint64 count) {
        uint256 totalTxs = broadcast.readStringArray(".transactions").length;
        for (uint32 i = 0; i < totalTxs; i++) {
            string memory txType = broadcast.readString(buildTxsPath(i, "transactionType"));
            if (txType.equal("CREATE")) count += 1;
        }

        return count;
    }

    /// @notice Load the broadcast json file
    /// @param targetFile The path of target file to load
    /// @param chainId The chain id of the broadcast
    /// @param time The timestamp of the broadcast e.g run-<timestamp>
    function load(string memory targetFile, uint256 chainId, string memory time)
        internal
        view
        returns (string memory json)
    {
        string memory latestRunPath =
            string.concat("broadcast/", targetFile, "/", vm.toString(chainId), "/", time, ".json");
        json = vm.readFile(latestRunPath);
    }

    function buildTxsPath(uint32 index, string memory field) internal pure returns (string memory) {
        return string.concat("$.transactions[", vm.toString(index), "].", field);
    }
}

// function exportDeployments(string memory outputPath, string memory targetFile) internal {
//     exportDeployments(outputPath, targetFile, block.chainid, "run-latest");
// }

// function exportDeployments(string memory outputPath, string memory targetFile, uint256 chainId, string memory time)
//     internal
// {
//     if (!vm.exists(outputPath)) {
//         vm.createDir(outputPath, true);
//     }

//     string memory fileName = string.concat(outputPath, vm.toString(chainId), ".json");
//     string memory json = string.concat("{", loadDeployments(targetFile, chainId, time), "}");

//     vm.writeFile(fileName, json);
// }

/// ---- VIEW FUNCTIONS ---- ///

/// @notice Get all contracts deployed in a specific broadcast
// function loadDeployments(string memory targetFile, uint256 chainId, string memory time)
//     internal
//     view
//     returns (string memory contractsJson)
// {
//     string memory broadcast = load(targetFile, chainId, time);
//     uint256 totalTxs = broadcast.readStringArray(".transactions").length;

//     for (uint32 i = 0; i < totalTxs; i++) {
//         string memory txType = broadcast.readString(buildTxsPath(i, "transactionType"));

//         if (txType.equal("CREATE")) {
//             string memory contractName = broadcast.readString(buildTxsPath(i, "contractName"));
//             address contractAddress = broadcast.readAddress(buildTxsPath(i, "contractAddress"));

//             DeploymentData memory data = DeploymentData(contractName, contractAddress);
//             contractsJson = _join(contractsJson, _buildContractJson(data));
//         }
//     }
// }

/// ---- PRIVATE FUNCTIONS ---- ///

// function _join(string memory json, string memory newField) private pure returns (string memory) {
//     if (json.equal("")) {
//         return newField;
//     }

//     return string.concat(json, ",", newField);
// }

// function _buildContractJson(DeploymentData memory data) private pure returns (string memory) {
//     return string.concat('"', data.name, '": "', data.addr.toHexString(), '"');
// }
