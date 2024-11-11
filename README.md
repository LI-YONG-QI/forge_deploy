# Forge Deploy

Forge Deploy aims to improve the deployment experience for developers by offering a quick and standardized deployment pattern suited for small to medium-sized projects. It reduces the need for handling multi-chain and cross-state deployment issues. Large projects can also benefit by customizing their own requirements using the provided library.

Forge Deploy includes a library for reading broadcast data, allowing for filtering and exporting specific data to files. Additionally, various deployment-friendly features will continue to be added in the future, such as setting parameters for different chains and automatically generating verification scripts.

# Why Forge Deploy?

Foundry lacks comprehensive functionality to assist with more complex contract deployment scenarios and does not offer a quick and convenient way to read/write data from broadcasts and other file. Unlike Hardhat, which supports TypeScript and Ignition Modular for writing flexible scripts, Foundry is limited to Solidity. Although it offers VM cheatcodes, some functions are still too low-level. Therefore, abstracting complex cheatcodes can help people get started quickly and build robust projects.

While reviewing the source code of various protocols, I've noticed that most of them require exporting deployed contract data. To achieve this, it’s necessary to read broadcast transaction data and then export it. However, repeatedly writing functions for querying is annoying, especially since developers often have similar requirements for development. Forge Deploy can help developers reduce the complexity of handling JSON data in these processes.

# Getting Started

## Setup

Clone repo

```sh
git clone https://github.com/LI-YONG-QI/forge_deploy.git
```

Anvil

```sh
anvil
```

## Demo

1. Check & Deploy `Token` contract with `Token.s.sol`

```sh
forge script script/Token.s.sol --broadcast --rpc-url 127.0.0.1:8545
```

Output:

```sh
== Logs ==
  Token address:  0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
```

2. Check & Deploy `Token2` contract with `Token2.s.sol`

The `Token2` contract constructor need to input deployed Token contract address

```sh
forge script script/Token2.s.sol --broadcast --rpc-url 127.0.0.1:8545
```

Output:

```sh
== Logs ==
  Token address:  0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
  Token2 address:  0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
```

# Libraries

The default values for `chainid` and `time` are `block.chainid and `run-latest` respectively.

The broadcast folder structure is `broadcast/targetFile/chainid/time.json`

## Broadcast

- `getContract(string memory targetFile, string memory contractName, uint256 chainId, string memory time)`

Get contract address from targetFile (e.g. Token.s.sol) in broadcast file.

- `loadDeployments(string memory targetFile, uint256 chainId, string memory time)`

Get all deployed contracts address in `broadcast/targetFile`

- `load(string memory targetFile, uint256 chainId, string memory time)`

Get all json data in targetFile
