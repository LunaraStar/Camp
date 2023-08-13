// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

contract BasicMath {

    function adder(uint _a, uint _b) public pure returns (uint, bool) {
        if (_a > type(uint).max - _b) {
            return (0, true);
        }
        return (_a + _b, false);
    }

    function subtractor(uint _a, uint _b) public pure returns (uint, bool) {
        if (_a < _b) {
            return (0, true);
        }
        return (_a - _b, false);
    }
}
