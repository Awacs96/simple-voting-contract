// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.19;

/// @title TBD
/// @author Inspired by the community, translated to Solidity by myself. Yours sincerely, Tom
/// @notice TBD
/// @dev TBD
contract VotingContract {

    // #############################
    //            ERRORS
    // #############################

    error VotingContract__PartyNameIsAlreadyTaken();

    // #############################
    //        STATIC VARIABLES
    // #############################

    struct PoliticalParty {
        string partyName;
        uint256 votes;
        uint256 electionNumber;
        address partyLeader;
        string[3] coalitionPartners;
        bool isInCoalition;
        mapping(address => bool) coalitionRequests;
    }

    uint256 public s_electionNumber;
    mapping(bytes32 partyNameHash => bool isTaken) s_partyNameIsTaken;
    mapping(address partyLeader => PoliticalParty) s_leaderToParty;

    PoliticalParty[] public s_politicalParties;

    // #############################
    //            EVENTS
    // #############################

    event PoliticalPartyRegistered(uint256 indexed electionNumber, address indexed partyLeader, string partyName);

    // #############################
    //           MODIFIERS
    // #############################

    // #############################
    //          FUNCTIONS
    // #############################

    function registerParty(string calldata _partyName) external {
        bytes32 nameHash = bytes32(keccak256(abi.encodePacked(_partyName)));
        if (s_partyNameIsTaken[nameHash]) {
            revert VotingContract__PartyNameIsAlreadyTaken();
        }

        s_partyNameIsTaken[nameHash] = true;
        s_electionNumber++;
        PoliticalParty memory party = PoliticalParty({partyName: _partyName, votes: 0, electionNumber: s_electionNumber, partyLeader: msg.sender, isInCoalition: false});
        s_politicalParties.push(party);
        s_leaderToParty[msg.sender] = party;

        emit PoliticalPartyRegistered(electionNumber, partyLeader, partyName);
    }

    function offerCoalition(string calldata _coalitionPartyName) external {
        
    }

    function withdrawCoalitionOffer(string calldata _coalitionPartyName) external {
        // reuqest exists (MDF-2)
        // msg.sender is party leader
    }

    function acceptCoalition(string calldata _coalitionPartyName) external {
        // request exists (MDF-2)
        // request is valid
        // can be accepted only by party leader
        // did not exceed the maximum of coalition members
    }

    function dismissCoalition() external {
        // should require approval from all party owners
    }

    function removeFromCoalition(string calldata _coalitionPartyName) external returns(bool) {
        // requires owners of all other parties
    }

    function leaveCoalition() external {}

    function startElection() external {}

    function showVotingResults() external {}

    // #############################
    //      INTERNAL FUNCTIONS
    // #############################

    function partyExists(string memory _partyName) internal returns(bool) {}

    function _setupElection() internal {}

    function _calculateSeats() internal {}

    function _cleanUp() internal {}

    // #############################
    //     VIEW & PURE FUNCTIONS
    // #############################

    function getNumberOfRegisteredParties() public view returns(uint256) {
    }

    function listRegisteredSubjects() public view returns(Subject[] memory) {
    }

    function showPoliticalPartyInformation(uint256 registrationNumber) public view returns(PoliticalParty memory) {
    }

    function showSubjecInformation(uint256 electionNumber) public view returns(Subject memory) {
    }



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