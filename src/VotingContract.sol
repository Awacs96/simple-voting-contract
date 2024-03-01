// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.19;

/// @title TBD
/// @author Inspired by the community, yours sincerely, Tom
/// @notice TBD
/// @dev TBD
contract VotingContract {

    // #############################
    //            ERRORS
    // #############################

    error VotingContract__PartyNameAlreadyExists();
    error VotingContract__OnlyPartyLeaderCanOfferCoalition();

    // #############################
    //        STATIC VARIABLES
    // #############################

    struct PoliticalParty {
        string subjectName;
        address partyLeader;
        bool inCoalition;
        uint8 coalitionRequestsReceived;
    }

    struct Subject {
        string subjectName;
        PoliticalParty[3] coalitionMembers;
        address subjectLeader;
    }

    PoliticalParty[] public s_politicalParties;
    Subject[] public s_eligibleSubjects;

    uint256 internal s_electionNumber;
    mapping(bytes32 partyName => bool isTaken) s_partyNameExists;
    mapping(address partyLeader=> PoliticalParty potentialPartner) s_leaderToParty;
    mapping(address partyLeader => PoliticalParty[] requests) s_coalitionRequested;

    // #############################
    //            EVENTS
    // #############################

    event PoliticalPartyRegistered(uint256 indexed electionNumber, string partyName, address partyLeader);

    // #############################
    //           MODIFIERS
    // #############################

    modifier onlyPartyLeaderCanOffer() {
        if (s_leaderToParty[msg.sender].partyLeader == address(0)) {
            revert VotingContract__OnlyPartyLeaderCanOfferCoalition();
        }
        _;
    }

    // #############################
    //          FUNCTIONS
    // #############################

    // better-practice: require some deposit or somehow limit the possibility to register a party ... maybe even make it onlyOwner but that would then be labor-intensive to register all parties
    // check na přetečení byte32
    function registerParty(string calldata _partyName) external {
        bytes32 partyNameHash = bytes32(keccak256(abi.encodePacked(_partyName)));

        if (s_partyNameExists[partyNameHash]) {
            revert VotingContract__PartyNameAlreadyExists();
        }

        s_partyNameExists[partyNameHash] = true;
        PoliticalParty memory party = PoliticalParty({subjectName: _partyName, partyLeader: msg.sender, inCoalition: false, coalitionRequestsReceived: 0});
        s_politicalParties.push(party);

        emit PoliticalPartyRegistered(s_electionNumber++, _partyName, msg.sender);
    }

    function offerCoalition(address _coalitionPartyLeader) external onlyPartyLeaderCanOffer {}

    function acceptCoalition() external {}

    function dismissCoalition() external {
        // should require approval from all party owners
    }

    function removeFromCoalition(PoliticalParty calldata subject) external returns(bool) {
        // requires owners of all other parties
    }

    function leaveCoalition() external {}

    function listRegisteredSubjects() external {}

    function startElection() external {}

    function showResults() external {}

    function showSubjectInformation() external view returns(Subject memory) {}

    function _cleanUp() internal {}

    // #############################
    //     VIEW & PURE FUNCTIONS
    // #############################

    function getNumberOfRegisteredParties() public view returns(uint256) {
        return s_politicalParties.length;
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