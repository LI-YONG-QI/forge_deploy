// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract Token {
    uint256 number;

    constructor(uint256 _number) {
        number = _number;
    }
}

contract Token2 {
    bool isTrue;

    constructor(bool _isTrue) {
        isTrue = _isTrue;
    }
}
