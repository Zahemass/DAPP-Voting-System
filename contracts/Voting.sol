// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        string position;
        string department;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(string => uint) public departmentWinners; // Maps department to winner ID
    mapping(address => bool) public hasVoted;
    uint public candidatesCount;
    uint public startTime;
    uint public endTime;

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "You have already voted.");
        _;
    }

    modifier withinVotingPeriod() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting is not allowed at this time.");
        _;
    }

    function addCandidate(string memory _name, string memory _position, string memory _department) public onlyAdmin {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, _position, _department, 0);
    }

    function finalizeCandidates() public onlyAdmin {
        require(block.timestamp > endTime, "Voting period has not ended yet.");
        calculateWinners();
    }

    function setVotingTimes(uint _startTime, uint _endTime) public onlyAdmin {
        require(_endTime > _startTime, "End time must be after start time.");
        startTime = _startTime;
        endTime = _endTime;
    }

    function vote(uint _candidateId) public withinVotingPeriod hasNotVoted {
        candidates[_candidateId].voteCount++;
        hasVoted[msg.sender] = true;
    }

    event WinnerCalculated(string department, string winnerName, uint voteCount);

function calculateWinners() internal {
    for (uint i = 1; i <= candidatesCount; i++) {
        Candidate memory candidate = candidates[i];
        if (departmentWinners[candidate.department] == 0 || candidate.voteCount > candidates[departmentWinners[candidate.department]].voteCount) {
            departmentWinners[candidate.department] = candidate.id;
        }
    }

    // Emit events after calculation
    for (uint i = 1; i <= candidatesCount; i++) {
        string memory dept = candidates[i].department;
        if (departmentWinners[dept] == candidates[i].id) {
            emit WinnerCalculated(dept, candidates[i].name, candidates[i].voteCount);
        }
    }
}


    function getWinner(string memory _department) public view returns (string memory, uint) {
        uint winnerId = departmentWinners[_department];
        // Ensure that the department has a winner
        require(winnerId > 0, "No winner for this department.");
        Candidate memory winner = candidates[winnerId];
        // Ensure that the winner exists
        require(bytes(winner.name).length > 0, "Winner candidate does not exist.");
        return (winner.name, winner.voteCount);
    }
}
