// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract FavoriteRecords {
    mapping (string => bool) public approvedRecords;
    mapping (address => mapping(string => bool)) userFavorites;
    string[] public approvedRecordsNames;
    error NotApproved(string _recordName);

    constructor(string[] memory _preapproved) {
        for (uint i = 0; i < _preapproved.length; i++) {
            require(!approvedRecords[_preapproved[i]], "Record Exist!");
            approvedRecords[_preapproved[i]] = true;
            approvedRecordsNames.push(_preapproved[i]);
        }
    }

    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordsNames;
    }

    function addRecord(string memory _recordName) public {
        if (approvedRecords[_recordName]) {
            userFavorites[msg.sender][_recordName] = true;
        } else {
            revert NotApproved(_recordName);
        }
    }

    function getUserFavorites(address _user) public view returns (string[] memory) {
        uint l = approvedRecordsNames.length;
        string[] memory tmp = new string[](l);
        uint cursor = 0;

        for (uint i = 0; i < l; i++) {
            if (userFavorites[_user][approvedRecordsNames[i]]) {
                tmp[cursor] = approvedRecordsNames[i];
                cursor++;
            }
        }

        string[] memory favorites = new string[](cursor);
        for (uint i = 0; i < cursor; i++) {
            favorites[i] = tmp[i];
        }

        return favorites;
    }

    function resetUserFavorites() public {
        for (uint i; i < approvedRecordsNames.length; i++) {
            userFavorites[msg.sender][approvedRecordsNames[i]] = false;
        }
    }


}
