// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract DecentralizedVoting {
    address public admin;
    mapping(string => uint256) private votes;
    mapping(address => bool) private hasVoted;
    string[] public candidates;

    event Voted(address indexed voter, string candidate);
    event CandidateAdded(string candidate);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    constructor(string[] memory _candidates) {
        admin = msg.sender;
        candidates = _candidates;
        for (uint256 i = 0; i < _candidates.length; i++) {
            votes[_candidates[i]] = 0;
        }
    }

    function vote(string memory _candidate) public {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(voteExists(_candidate), "Candidate does not exist.");
        votes[_candidate]++;
        hasVoted[msg.sender] = true;
        emit Voted(msg.sender, _candidate);
    }

    function getVotes(string memory _candidate) public view returns (uint256) {
        require(voteExists(_candidate), "Candidate does not exist.");
        return votes[_candidate];
    }

    function addCandidate(string memory _candidate) public onlyAdmin {
        require(!voteExists(_candidate), "Candidate already exists.");
        candidates.push(_candidate);
        votes[_candidate] = 0;
        emit CandidateAdded(_candidate);
    }

    function voteExists(string memory _candidate) internal view returns (bool) {
        for (uint256 i = 0; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidates[i])) == keccak256(abi.encodePacked(_candidate))) {
                return true;
            }
        }
        return false;
    }

    // New function: Get all candidates with their votes
    function getAllVotes() public view returns (string[] memory, uint256[] memory) {
        uint256[] memory allVotes = new uint256[](candidates.length);
        for (uint256 i = 0; i < candidates.length; i++) {
            allVotes[i] = votes[candidates[i]];
        }
        return (candidates, allVotes);
    }
}

