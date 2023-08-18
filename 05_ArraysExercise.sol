// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract ArraysExercise {
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];
    address[] senders;
    uint[] timestamps;

    function getNumbers() public view returns(uint[] memory) {
        return numbers;
    }

    function resetNumbers() public {
        numbers = [1,2,3,4,5,6,7,8,9,10];
    }

    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    function afterY2K() public view returns (uint[] memory, address[] memory) {
        uint count = 0;

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > 946702800) {
                count += 1;
            }
        }

        address[] memory _senders = new address[](count);
        uint[] memory _timestamps = new uint[](count);
        uint cursor = 0;

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > 946702800) {
                _timestamps[cursor] = timestamps[i];
                _senders[cursor] = senders[i];
                cursor++;
            }
            if (cursor == count) {
                break ;
            }
        }
        return (_timestamps, _senders);
    }

    function resetSenders() public {
        delete senders;
    }

    function resetTimestamps() public {
        delete timestamps;
    }
}
