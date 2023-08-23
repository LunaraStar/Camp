// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import {SillyStringUtils} from "./SillyStringUtils.sol";

contract ImportsExercise{
    using SillyStringUtils for SillyStringUtils.Haiku;

    SillyStringUtils.Haiku public haiku;

    function saveHaiku(string memory _l1, string memory _l2, string memory _l3) public {
        haiku.line1 = _l1;
        haiku.line2 = _l2;
        haiku.line3 = _l3;
    }

    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        SillyStringUtils.Haiku memory newHaiku = haiku;
        newHaiku.line3 = SillyStringUtils.shruggie(haiku.line3);
        return newHaiku;
    }
}
