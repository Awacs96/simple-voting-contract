// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.19;

/// @title This simple voting contract should allow users to create their own votes and allow users to cast votes for their candidates according to the Instant-runoff system
/// @author Inspired by the community, yours sincerely, Tom
/// @notice Ability to register whitelisted candidates (by passing a legal threshold, not in conflict with laws, etc.)
/// @dev TBD
contract VotingContract {

    // #############################
    //            ERRORS
    // #############################

    error VotingContract__CandidateNotWhitelisted();
    error VotingContract__IsNotTheOwner();

    // #############################
    //           EVENTS
    // #############################

    event VotingStarted();
    event CandidateRegistered(uint256 indexed candidateId, address candidateIdentifier);

    // #############################
    //           EVENTS
    // #############################

    modifier onlyOwner() {
        if (msg.sender != s_owner) {
            revert VotingContract__IsNotTheOwner();
        }
        _;
    } 

    // #############################
    //      STATIC VARIABLES
    // #############################

    enum RegisteredParties {
        LEFT,
        RIGHT,
        FAR_RIGHT,
        FAR_LEFT,
        CENTRIST
    }

    struct Candidate {
        bytes32 name;
        RegisteredParties affiliation;
        address identifier;
        uint8 age;
        uint8 number;
    }

    Candidate[] internal candidates;

    uint8 public constant MAXIMUM_CANDIDATES = 6;
    address private s_owner;

    // #############################
    //        FUNCTIONS
    // #############################

    constructor() {
        s_owner = msg.sender;
    }

    // #############################
    //       EXTERNAL FUNCTIONS
    // #############################

    /// @notice This function registeres a new candidate that is whitelisted, if the total number of candidates is not yet reached
    /// @param candidateName a name of the candidate
    /// @param candidateAffiliation political possition of the candidate
    /// @param candidateId address of the candidate address
    /// @param candidateAge age of the candidate
    function registerCandidate(bytes32 candidateName, RegisteredParties candidateAffiliation, address candidateId, uint8 candidateAge) external returns (uint8 candidateNumber) {
        // Cannot register if the maximum number of candidates way reached
        // Cannot register with incorrect political affiliation
        // Cannot register if the age is below 18

    }

    function castVote() external {}

    function openVoting() external {}

    function remainingTime() external returns (uint256) {}

    function closeRegistration() external {}

    function getResults() external {}

    function _whitelistCandidate() internal {}

}
