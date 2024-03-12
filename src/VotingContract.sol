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

    error VotingContract__NameIsAlreadyTaken();
    error VotingContract__SenderIsNotAPartyChair();
    error VotingContract__PartyDoesNotExist();
    error VotingContract__MaximumPartiesHasBeenReached();
    error VotingContract__CannotCreateCoalitionWithItself();
    error VotingContract__CoalitionHasAlreadyBeenRequested();
    error VotingContract__VotingAlreadyStarted();
    error VotingContract__ColitionWasNotRequested();
    error VotingContract__CoalitionRequestDoesNotExist();

    // #############################
    //        STATIC VARIABLES
    // #############################

    uint8 public immutable MAXIMUM_PARTIES_TO_REGISTER = 50;

    struct Party {
        uint8 registrationNumber;
        address chairPerson;
        string partyName;
        string[] partners;
    }

    struct Subject {
        string subjectName;
        string[] memberParties;
        address[] chairPeople;
        uint256 votes;
        uint8 electionNumber;
        uint8 threshold;
    }

    Party[] s_registeredParties;
    Subject[] s_registeredSubjects;

    uint8 internal s_registrationNumber;
    bool public s_votingPhase;

    mapping(address chairPerson => Party) public s_chairToParty;
    mapping(bytes32 nameHash => Party) public s_hashToParty;
    mapping(uint8 index => Party) public s_registrationNumberToParty;
    mapping(bytes32 party1Hash => mapping(bytes32 party2Hash => bool)) public s_coalitionRequests;

    // #############################
    //            EVENTS
    // #############################

    event PartyRegistered(string indexed party, address indexed chair, uint indexed timestamp);
    event CoalitionRequested(string indexed offeringParty, string indexed requestedParty, uint indexed timestamp);
    event CoalitionRequestWithdrawn(string indexed offeringParty, string indexed requestedParty, uint indexed timestamp);

    // #############################
    //           MODIFIERS
    // #############################

    // #############################
    //          FUNCTIONS
    // #############################

    function registerParty(string calldata partyName) external {
        bytes32 nameHash = keccak256(abi.encodePacked(partyName));

        if (s_registeredParties.length >= MAXIMUM_PARTIES_TO_REGISTER) {
            revert VotingContract__MaximumPartiesHasBeenReached();
        }

        if (s_hashToParty[nameHash].chairPerson != address(0)) {
            revert VotingContract__NameIsAlreadyTaken();
        }

        string[] memory emptyArray;
        Party memory party = Party({
            registrationNumber: s_registrationNumber,
            chairPerson: msg.sender,
            partyName: partyName,
            partners: emptyArray
        });
        s_registeredParties.push(party);
        s_registrationNumberToParty[s_registrationNumber] = party;
        s_registrationNumber++;

        emit PartyRegistered(partyName, msg.sender, block.timestamp);
    }

    function offerCoalition(string calldata coalitionPartyName) external {
        if (s_chairToParty[msg.sender].chairPerson == address(0)) {
            revert VotingContract__SenderIsNotAPartyChair();
        }

        string memory offeringPartyName = s_chairToParty[msg.sender].partyName;
        bytes32 offeringNameHash = keccak256(abi.encodePacked(offeringPartyName));
        bytes32 partnerNameHash = keccak256(abi.encodePacked(coalitionPartyName));
        if (s_hashToParty[partnerNameHash].chairPerson == address(0)) {
            revert VotingContract__PartyDoesNotExist();
        }

        if (offeringNameHash == partnerNameHash) {
            revert VotingContract__CannotCreateCoalitionWithItself();
        }

        if (s_coalitionRequests[offeringNameHash][partnerNameHash] || s_coalitionRequests[partnerNameHash][offeringNameHash]) {
            revert VotingContract__CoalitionHasAlreadyBeenRequested();
        }

        if (s_votingPhase) {
            revert VotingContract__VotingAlreadyStarted();
        }

        s_coalitionRequests[offeringNameHash][partnerNameHash] = true;

        emit CoalitionRequested(offeringPartyName, coalitionPartyName, block.timestamp);
    }

    function withdrawCoalitionOffer(string calldata coalitionPartyName) external {
        if (s_chairToParty[msg.sender].chairPerson == address(0)) {
            revert VotingContract__SenderIsNotAPartyChair();
        }

        string memory offeringPartyName = s_chairToParty[msg.sender].partyName;
        bytes32 offeringNameHash = keccak256(abi.encodePacked(offeringPartyName));
        bytes32 partnerNameHash = keccak256(abi.encodePacked(coalitionPartyName));
        if (s_hashToParty[partnerNameHash].chairPerson == address(0)) {
            revert VotingContract__PartyDoesNotExist();
        }

        if (!s_coalitionRequests[offeringNameHash][partnerNameHash]) {
            revert VotingContract__ColitionWasNotRequested();
        }

        if (s_votingPhase) {
            revert VotingContract__VotingAlreadyStarted();
        }

        s_coalitionRequests[offeringNameHash][partnerNameHash] = false;

        emit CoalitionRequestWithdrawn(offeringPartyName, coalitionPartyName, block.timestamp);
    }

    function acceptCoalition(string calldata coalitionPartyName) external {
        if (s_chairToParty[msg.sender].chairPerson == address(0)) {
            revert VotingContract__SenderIsNotAPartyChair();
        }

        if (s_votingPhase) {
            revert VotingContract__VotingAlreadyStarted();
        }

        string memory ownPartyName = s_chairToParty[msg.sender].partyName;
        bytes32 ownNameHash = keccak256(abi.encodePacked(ownPartyName));
        bytes32 partnerNameHash = keccak256(abi.encodePacked(coalitionPartyName));
        if (!s_coalitionRequests[partnerNameHash][ownNameHash]) {
            revert VotingContract__CoalitionRequestDoesNotExist();
        }


    }

    function dismissCoalition() external {}

    function removeFromCoalition(string calldata _coalitionPartyName) external returns(bool) {}

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

    function getNumberOfRegisteredParties() public view returns(uint256) {}

    function listRegisteredSubjects() public view {}

    function showPoliticalPartyInformation(uint256 registrationNumber) public view {}

    function showSubjecInformation(uint256 electionNumber) public view {}



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