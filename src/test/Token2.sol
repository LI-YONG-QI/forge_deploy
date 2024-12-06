pragma solidity ^0.8.20;

import {Token} from "./Token.sol";

contract Token2 {
    Token public token;
    uint256 public x;
    uint256 public y;

    constructor(uint256 _x, uint256 _y, Token _token) {
        x = _x;
        y = _y;
        token = _token;
    }
}
