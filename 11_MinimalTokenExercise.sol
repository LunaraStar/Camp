// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;


contract UnburnableToken {

    mapping (address => uint) public balances;
    mapping (address => bool) private claimed;
    uint public totalSupply;
    uint public totalClaimed;

    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address);

    constructor() {
        totalSupply = 100000000;
    }

    function claim() public {
        if (claimed[msg.sender]) {
            revert TokensClaimed();
        }
        if (totalClaimed + 1000 > totalSupply) {
            revert AllTokensClaimed();
        }

        totalClaimed += 1000;
        balances[msg.sender] += 1000;
        claimed[msg.sender] = true;
    }

    function safeTransfer(address _to, uint _amount) public {
        if (_to == address(0) || _to.balance == 0 || balances[msg.sender] < _amount) {
            revert UnsafeTransfer(_to);
        }
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
