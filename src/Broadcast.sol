// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

library Broadcast {
    using stdJson for *;
    using Strings for *;

    Vm internal constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    error ContractNotFound(string targetFile, string contractName, string timestamp, uint256 chainId);

    struct DeploymentData {
        string name;
        address addr;
    }

    function exportDeployments(string memory outputPath, string memory targetFile) internal {
        exportDeployments(outputPath, targetFile, block.chainid);
    }

    function exportDeployments(string memory outputPath, string memory targetFile, uint256 chainId) internal {
        if (!vm.exists(outputPath)) {
            vm.createDir(outputPath, true);
        }

        string memory fileName = string.concat(outputPath, vm.toString(chainId), ".json");
        string memory json = string.concat("{", loadDeployments(targetFile, chainId, "run-latest"), "}");

        vm.writeFile(fileName, json);
    }

    function loadDeployments(string memory targetFile, uint256 chainId, string memory time)
        internal
        view
        returns (string memory contractsJson)
    {
        string memory broadcast = load(targetFile, chainId, time);
        uint256 totalTxs = broadcast.readStringArray(".transactions").length;

        for (uint32 i = 0; i < totalTxs; i++) {
            string memory txType = broadcast.readString(_buildTxsPath(i, "transactionType"));

            if (txType.equal("CREATE")) {
                string memory contractName = broadcast.readString(_buildTxsPath(i, "contractName"));
                address contractAddress = broadcast.readAddress(_buildTxsPath(i, "contractAddress"));

                DeploymentData memory data = DeploymentData(contractName, contractAddress);
                contractsJson = _join(contractsJson, _buildContractJson(data));
            }
        }
    }

    function getContract(string memory targetFile, string memory contractName) internal view returns (address) {
        return getContract(targetFile, contractName, block.chainid, "run-latest");
    }

    function getContract(string memory targetFile, string memory contractName, uint256 chainId, string memory time)
        internal
        view
        returns (address)
    {
        string memory broadcast = load(targetFile, chainId, time);
        uint256 totalTxs = broadcast.readStringArray(".transactions").length;

        for (uint32 i = 0; i < totalTxs; i++) {
            string memory _contractName = broadcast.readString(_buildTxsPath(i, "contractName"));

            if (_contractName.equal(contractName)) {
                return broadcast.readAddress(_buildTxsPath(i, "contractAddress"));
            }
        }

        revert ContractNotFound(targetFile, contractName, time, chainId);
    }

    function load(string memory targetFile, uint256 chainId, string memory time)
        public
        view
        returns (string memory json)
    {
        string memory latestRunPath =
            string.concat("broadcast/", targetFile, "/", vm.toString(chainId), "/", time, ".json");
        json = vm.readFile(latestRunPath);
    }

    /// ---- PRIVATE FUNCTIONS ---- ///

    function _join(string memory json, string memory newField) private pure returns (string memory) {
        if (json.equal("")) {
            return newField;
        }

        return string.concat(json, ",", newField);
    }

    function _buildContractJson(DeploymentData memory data) private pure returns (string memory) {
        return string.concat('"', data.name, '": "', data.addr.toHexString(), '"');
    }

    function _buildTxsPath(uint32 index, string memory field) private pure returns (string memory) {
        return string.concat("$.transactions[", vm.toString(index), "].", field);
    }
}
