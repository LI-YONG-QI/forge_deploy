pragma solidity ^0.8.20;

contract Map {
    struct Point {
        uint256 x;
        uint256 y;
        uint8[] z;
    }

    uint256 public x = 0;
    uint256 public y = 0;
    uint8[] public z;
    uint256 public id;

    constructor(uint256 _id, Point memory p) {
        // Do something with p
        x = p.x;
        y = p.y;
        z = p.z;
        id = _id;
    }
}
