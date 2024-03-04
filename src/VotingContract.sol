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
    error VotingContract__PartyDoesNotExist();
    error VotingContract__CoalitionRequestAlreadyExists();
    error VotingContract__CannotCreateCoalitionWithOwnParty();
    error VotingContract__ReuqestDoesNotExist();

    // #############################
    //        STATIC VARIABLES
    // #############################

    struct PoliticalParty {
        string partyName;
        uint256 votes;
        uint256 electionNumber;
        uint256 numberOfPartners;
        address partyLeader;
        string[3] coalitionPartners;
        bool isInCoalition;
    }

    uint256 public s_electionNumber;
    mapping(bytes32 partyNameHash => bool isTaken) s_partyNameIsTaken;
    mapping(address partyLeader => PoliticalParty party) s_leaderToParty;
    mapping(string partyName => PoliticalParty party) s_nameToParty;
    mapping(address reuqestor => mapping(address requestee => bool isRequested)) s_coalitionRequested;
    mapping(address partyLeaderOne => mapping(address partyLeaderTwo => bool haveCoalition)) s_partiesAreInCoalition;

    PoliticalParty[] public s_politicalParties;

    // #############################
    //            EVENTS
    // #############################

    event PoliticalPartyRegistered(uint256 indexed electionNumber, address indexed partyLeader, string partyName);
    event CoalitionRequested(address indexed requestor, address indexed requestee, uint256 indexed timestamp, string requestingParty, string requestedParty);
    event RequestWithdrawn(string indexed withdrawingParty, string indexed withdrawedFrom, uint256 indexed timestamp);

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
        PoliticalParty memory party = PoliticalParty({partyName: _partyName, votes: 0, electionNumber: s_electionNumber, numberOfPartners: 0, partyLeader: msg.sender, coalitionPartners: ["", "", ""], isInCoalition: false});
        s_politicalParties.push(party);
        s_leaderToParty[msg.sender] = party;

        emit PoliticalPartyRegistered(s_electionNumber, msg.sender, _partyName);
    }

    function offerCoalition(string calldata _coalitionPartyName) external {
        if (s_leaderToParty[msg.sender].partyLeader == address(0)) {
            revert VotingContract__PartyDoesNotExist();
        }

        if (s_nameToParty[_coalitionPartyName].partyLeader == address(0)) {
            revert VotingContract__PartyDoesNotExist();
        }

        address coalitionPartyLeader = s_nameToParty[_coalitionPartyName].partyLeader;

        if (s_coalitionRequested[coalitionPartyLeader][msg.sender] || s_coalitionRequested[msg.sender][coalitionPartyLeader]) {
            revert VotingContract__CoalitionRequestAlreadyExists();
        }

        if (msg.sender == coalitionPartyLeader) {
            revert VotingContract__CannotCreateCoalitionWithOwnParty();
        }

        s_coalitionRequested[msg.sender][coalitionPartyLeader] = true;
        string memory requestingPartyName = s_leaderToParty[msg.sender].partyName;
        string memory requestedPartyName = s_leaderToParty[coalitionPartyLeader].partyName;

        emit CoalitionRequested(msg.sender, coalitionPartyLeader, block.timestamp, requestingPartyName, requestedPartyName);
    }

    function withdrawCoalitionOffer(string calldata _coalitionPartyName) external {
        address coalitionPartyLeader = s_nameToParty[_coalitionPartyName].partyLeader;

        if (!s_coalitionRequested[msg.sender][coalitionPartyLeader]) {
            revert VotingContract__ReuqestDoesNotExist();
        }

        s_coalitionRequested[msg.sender][coalitionPartyLeader] = false;
        string memory partyName = s_leaderToParty[msg.sender].partyName;

        emit RequestWithdrawn(partyName, _coalitionPartyName, block.timestamp);
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

    function listRegisteredSubjects() public view {
    }

    function showPoliticalPartyInformation(uint256 registrationNumber) public view {
    }

    function showSubjecInformation(uint256 electionNumber) public view {
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