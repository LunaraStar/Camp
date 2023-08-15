// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract EmployeeStorage {

    uint16 private shares;
    uint32 private salary;
    string public name;
    uint256 public idNumber;

    error TooManyShares(uint256 shares);

    constructor(uint256 _shares, string memory _name, uint256 _salary, uint256 _idNumber) {
        
        require(_shares <= 5000, "Invalid Shares");
        require(_salary <= 1000000, "Invalid Salary");

        shares = uint16(_shares);
        name = _name;
        salary = uint32(_salary);
        idNumber = _idNumber;
    }

    function viewSalary() public view returns (uint32) {
        return salary;
    }

    function viewShares() public view returns (uint16) {
        return shares;
    }

    function grantShares(uint16 _newShares) public {
        if (_newShares > 5000) {
            revert("Too many shares");
        }
        if (_newShares > 5000 - shares) {
            revert TooManyShares(shares + _newShares);
        }
        shares += _newShares;
    }

    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload(_slot)
        }
    }

    function debugResetShares() public {
        shares = 1000;
    }
}
