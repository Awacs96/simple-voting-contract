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
    error VotingContract__CoalitionAlreadyRequested();
    error VotingContract_AlreadyInCoalition();

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
        string[3] coalitionMembers;
        address subjectLeader;
    }

    PoliticalParty[] public s_politicalParties;
    Subject[] public s_eligibleSubjects;

    uint256 internal s_electionNumber;
    uint256 internal s_registrationNumber;
    mapping(bytes32 partyName => bool isTaken) s_partyNameExists;
    mapping(address partyLeader=> PoliticalParty potentialPartner) s_leaderToParty;
    mapping(address requestor => mapping(address requestee => bool wasRequested)) s_coalitionRequested;
    mapping(address partyLeader => mapping(address otherPartyLeader => bool isInCoalition)) s_inCoalition;

    // #############################
    //            EVENTS
    // #############################

    event PoliticalPartyRegistered(uint256 indexed electionNumber, string partyName, address partyLeader);

    // #############################
    //           MODIFIERS
    // #############################

    modifier onlyPartyLeaderCanOfferCoalition() {
        if (s_leaderToParty[msg.sender].partyLeader == address(0)) {
            revert VotingContract__OnlyPartyLeaderCanOfferCoalition();
        }
        _;
    }

    modifier coalitionNotYetRequested(address _coalitionLeader) {
        if (s_coalitionRequested[msg.sender][_coalitionLeader]) {
            revert VotingContract__CoalitionAlreadyRequested();
        }
        _;
    }

    modifier notACoalitionMember(address _coalitionLeader) {
        if (s_inCoalition[msg.sender][_coalitionLeader]) {
            revert VotingContract_AlreadyInCoalition();
        }
        _;
    }

    modifier partyExists() {
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

        emit PoliticalPartyRegistered(s_registrationNumber++, _partyName, msg.sender);
    }

    // Možná udělat vytváření koalic ne podle adresy předsedy ale jména? Bude to víc gas-náročné thou
    function offerCoalition(address _coalitionPartyLeader) external onlyPartyLeaderCanOfferCoalition coalitionNotYetRequested(_coalitionPartyLeader) notACoalitionMember(_coalitionPartyLeader) {
        // s_coalitionRequested[]
    }

    function acceptCoalition() external {}

    function dismissCoalition() external {
        // should require approval from all party owners
    }

    function removeFromCoalition(PoliticalParty calldata subject) external returns(bool) {
        // requires owners of all other parties
    }

    function leaveCoalition() external {}

    function startElection() external {}

    function showResults() external {}

    function _cleanUp() internal {}

    // #############################
    //     VIEW & PURE FUNCTIONS
    // #############################

    function getNumberOfRegisteredParties() public view returns(uint256) {
        return s_politicalParties.length;
    }

    function listRegisteredSubjects() public view returns(Subject[] memory) {
        return s_eligibleSubjects;
    }

    function showPoliticalPartyInformation(uint256 registrationNumber) public view returns(PoliticalParty memory) {
        return s_politicalParties[registrationNumber];
    }

    function showSubjecInformation(uint256 electionNumber) public view returns(Subject memory) {
        return s_eligibleSubjects[electionNumber];
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