// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh();
    error AlreadyVoted();
    error VotingClosed();

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;

        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;

        bool passed;
        bool closed;
    }

    struct PublicIssue {
        address[] voters;
        string issueDesc;

        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;

        bool passed;
        bool closed;
    }

    enum Vote {
        AGAINST, FOR, ABSTAIN
    }

    Issue[] private _issues;
    mapping (address => bool) private claimed;
    uint private maxSupply = 1000000;

    

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        _issues.push();
        _issues[0].closed = true;
    }

    function claim() external {
        if (claimed[msg.sender]) {
            revert TokensClaimed();
        }
        if (maxSupply == totalSupply()) {
            revert AllTokensClaimed();
        }
        claimed[msg.sender] = true;
        _mint(msg.sender, 100);
    }

    function createIssue(string calldata _name, uint _quorum) external returns (uint) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh();
        }
        Issue storage newIssue = _issues.push();
        newIssue.issueDesc = _name;
        newIssue.quorum = _quorum;
        return _issues.length - 1;
    }

    function getIssue(uint _id) external view returns (PublicIssue memory) {
        Issue storage issue = _issues[_id];
        return PublicIssue(
            issue.voters.values(),
            issue.issueDesc,
            issue.votesFor,
            issue.votesAgainst,
            issue.votesAbstain,
            issue.totalVotes,
            issue.quorum,
            issue.passed,
            issue.closed
        );
    }

    function vote(uint _issueId, Vote _vote) public {
        Issue storage issue = _issues[_issueId];

        if (issue.closed) {
            revert VotingClosed();
        }
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }
        
        uint voterBalance = balanceOf(msg.sender);

        if (voterBalance == 0) {
            revert NoTokensHeld();
        }
        
        issue.voters.add(msg.sender);

        if (_vote == Vote.AGAINST) {
            issue.votesAgainst += voterBalance;
        } else if (_vote == Vote.ABSTAIN) {
            issue.votesAbstain += voterBalance;
        } else {
            issue.votesFor += voterBalance;
        }
        issue.totalVotes += voterBalance;

        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            issue.passed =  issue.votesFor > issue.votesAgainst;
        }
    }
}
