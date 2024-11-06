// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

library File {
    using stdJson for *;
    using Strings for *;

    Vm internal constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    error ContractNotFound(string deployFile, string contractName, string timestamp, uint256 chainId);

    struct Data {
        string name;
        address addr;
    }

    function exportContracts(string memory outputPath, string memory deployFile, uint256 chainId) internal {
        if (!vm.exists(outputPath)) {
            vm.createDir(outputPath, true);
        }

        string memory fileName = string.concat(outputPath, vm.toString(chainId), ".json");
        string memory json = string.concat("{", getDeployedContracts(deployFile, chainId, "run-latest"), "}");
        vm.writeFile(fileName, json);
    }

    function getDeployedContracts(string memory deployFile, uint256 chainId, string memory time)
        internal
        view
        returns (string memory)
    {
        string memory latestRunPath =
            string.concat("broadcast/", deployFile, "/", vm.toString(chainId), "/", time, ".json");
        string memory latestRun = vm.readFile(latestRunPath);
        uint256 totalTxs = latestRun.readStringArray(".transactions").length;

        string memory contractsJson = "";

        for (uint32 i = 0; i < totalTxs; i++) {
            string memory txType = latestRun.readString(buildTxsPath(i, "transactionType"));
            if (txType.equal("CREATE")) {
                string memory contractName = latestRun.readString(buildTxsPath(i, "contractName"));
                address contractAddress = latestRun.readAddress(buildTxsPath(i, "contractAddress"));

                Data memory data = Data(contractName, contractAddress);
                contractsJson = string.concat(contractsJson, buildContractJson(data));
            }
        }

        return contractsJson;
    }

    function getContract(string memory deployFile, string memory contractName) internal view returns (address) {
        return getContract(deployFile, contractName, "run-latest", block.chainid);
    }

    function getContract(string memory deployFile, string memory contractName, string memory time, uint256 chainId)
        internal
        view
        returns (address)
    {
        string memory latestRunPath =
            string.concat("broadcast/", deployFile, "/", vm.toString(chainId), "/", time, ".json");
        string memory latestRun = vm.readFile(latestRunPath);
        uint256 totalTxs = latestRun.readStringArray(".transactions").length;

        for (uint32 i = 0; i < totalTxs; i++) {
            string memory _contractName = latestRun.readString(buildTxsPath(i, "contractName"));

            if (_contractName.equal(contractName)) {
                return latestRun.readAddress(buildTxsPath(i, "contractAddress"));
            }
        }

        revert ContractNotFound(deployFile, contractName, time, chainId);
    }

    function buildContractJson(Data memory data) internal pure returns (string memory) {
        return string.concat('"', data.name, '": {"address": "', data.addr.toHexString(), '"},');
    }

    function buildTxsPath(uint32 index, string memory field) private pure returns (string memory path) {
        path = string.concat("$.transactions[", vm.toString(index), "].", field);
    }
}
