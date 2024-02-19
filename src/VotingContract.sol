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

    // #############################
    //           EVENTS
    // #############################

    event VotingStarted();
    event CandidateRegistered(uint256 indexed candidateId, address candidateIdentifier);

    // #############################
    //      STATIC VARIABLES
    // #############################

    struct Candidate {
        bytes32 name;
        bytes32 district;
        bytes32 politicalAffiliation;
        address identifier;
        uint8 age;
        uint8 id;
    }

    Candidate[] internal candidates;

}
