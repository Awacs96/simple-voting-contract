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

    error VotingContract__PartyNameAlreadyExists();

    // #############################
    //        STATIC VARIABLES
    // #############################

    struct PoliticalParty {
        bytes32 subjectName;
        address partyLeader;
        bool inCoalition;
    }

    struct Subject {
        bytes32 subjectName;
        PoliticalParty[] coalitionMembers;
        address subjectLeader;
    }

    PoliticalParty[] s_politicalParties;
    Subject[] s_eligibleSubjects;

    uint256 internal s_electionNumber;
    mapping(bytes32 => bool) s_partyNameExists;

    // #############################
    //            EVENTS
    // #############################

    event PoliticalPartyRegistered(uint256 indexed electionNumber, bytes32 partyName, address partyLeader);

    // #############################
    //          FUNCTIONS
    // #############################

    // better-practice: require some deposit or somehow limit the possibility to register a party ... maybe even make it onlyOwner but that would then be labor-intensive to register all parties
    function registerParty(string calldata _partyName) external {
        bytes32 partyNameHash = bytes32(keccak256(abi.encodePacked(_partyName)));

        if (s_partyNameExists[partyNameHash]) {
            revert VotingContract__PartyNameAlreadyExists();
        }

        s_partyNameExists[partyNameHash] = true;
        PoliticalParty storage party = PoliticalParty({subjectName: _partyName, partyLeader: msg.sender, inCoalition: false});
        s_politicalParties.push(party);
        
        emit PoliticalPartyRegistered(s_electionNumber++, _partyName, msg.sender);
    }

    function createCoalition() external {
        // should require approval from all party owners
    }

    function dismissCoalition() external {
        // should require approval from all party owners
    }

    function removeFromCoalition(PoliticalParty subject) external returns(bool) {
        // requires owners of all other parties
    }

    function listRegisteredSubjects() external {}

    function startElection() external {}

    function showResults() external {}

    function showSubjectInformation() external view returns(Subject memory) {}

    function _cleanUp() internal {}



// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

}