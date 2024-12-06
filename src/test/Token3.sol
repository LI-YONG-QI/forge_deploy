pragma solidity ^0.8.20;

import {Token} from "./Token.sol";

contract Token3 {
    bool public a;
    uint256 public b;

    constructor(bool _a, uint256 _b) {
        a = _a;
        b = _b;
    }
}
