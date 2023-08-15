// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract ControlStructures {

    error AfterHours(uint _time);

    function fizzBuzz(uint _number) public pure returns (string memory) {
        
        bool div3 = _number % 3 == 0;
        bool div5 = _number % 5 == 0;

        if (div3 && div5) {
            return "FizzBuzz";
        }
        else if (div3) {
            return "Fizz";
        }
        else if (div5) {
            return "Buzz";
        }
        else {
            return "Splat";
        }
    }

    function doNotDisturb(uint _time) public pure returns (string memory) {

        assert(_time < 2400);
        if (_time < 800) {
            revert AfterHours(_time);
        }
        if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        }
        else if (_time <= 1259) {
            revert ("At lunch!");
        }
        else if (_time <= 1799) {
            return "Afternoon!";
        }
        else if (_time <= 2199) {
            return "Evening!";
        }
        revert AfterHours(_time);
    }
}
