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

    error VotingContract__VotingPhaseAlreadyStarted();
    error VotingContract__PartyNameAlreadyExists();
    error VotingContract__PartyNameDoesNotExist();
    error VotingContract__OnlyPartyLeaderCanOfferCoalition();
    error VotingContract__CoalitionAlreadyRequested();
    error VotingContract__AlreadyInCoalition();
    error VotingContract__CoalitionBetweenThesePartiesHasBeenAlreadyRequested();
    error VotingContract__MaximumPartyCapacityReached();

    // #############################
    //        STATIC VARIABLES
    // #############################

    struct PoliticalParty {
        string subjectName;
        address partyLeader;
        bool inCoalition;
        uint8 coalitionRequestsSent;
    }

    struct Subject {
        string subjectName;
        string[3] coalitionMembers;
        address subjectLeader;
        bool isCoalition;
        uint256 votes;
    }

    uint256 public constant MAXIMUM_COALITION_REQUESTS = 5;
    uint256 public constant MAXIMUM_PARTIES_TO_REGISTER = 50;
    uint256 internal s_registrationNumber;
    uint256 internal s_electionNumber;
    bool public votingPhase;
    mapping(string partyName => bool isTaken) s_partyNameExists;
    mapping(string partyName => address partyLeader) s_partyNameToLeader;
    mapping(address partyLeader => PoliticalParty party) s_leaderToParty;
    mapping(address requestor => mapping(address requestee => bool wasRequested)) s_coalitionRequestExists;
    mapping(address partyLeader => mapping(address otherPartyLeader => bool isInCoalition)) s_inCoalition;

    PoliticalParty[MAXIMUM_PARTIES_TO_REGISTER] public s_politicalParties;
    Subject[] public s_eligibleSubjects;

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

    modifier onlyPartyLeader() {
        if (s_leaderToParty[msg.sender] !=)
    }

    modifier coalitionNotYetRequested(string calldata _coalitionPartyName) {
        address coalitionPartyLeader = s_partyNameToLeader[_coalitionPartyName];
        if (s_coalitionRequestExists[msg.sender][coalitionPartyLeader] || s_coalitionRequestExists[coalitionPartyLeader][msg.sender]) {
            revert VotingContract__CoalitionBetweenThesePartiesHasBeenAlreadyRequested();
        }
        _;
    }

    modifier notACoalitionMember(address _coalitionLeader) {
        if (s_inCoalition[msg.sender][_coalitionLeader]) {
            revert VotingContract__AlreadyInCoalition();
        }
        _;
    }

    modifier votingIsClosed() {
        if (votingPhase) {
            revert VotingContract__VotingPhaseAlreadyStarted();
        }
        _;
    }

    modifier partyNumberDoesNotExceedCapacity() {
        if (s_registrationNumber >= 50) {
            revert VotingContract__MaximumPartyCapacityReached();
        }
        _;
    }

    // #############################
    //          FUNCTIONS
    // #############################

    // better-practice: require some deposit or somehow limit the possibility to register a party ... maybe even make it onlyOwner but that would then be labor-intensive to register all parties
    // check na přetečení byte32
    /// @notice Function registers a new party, checks that the party name does not yet exist and creates the PoliticalParty in storage, this function also takes the msg.sender as the partyLeader
    /// @dev Reuqested implementation of checks so that this function cannot be smapped
    /// @param _partyName a string parameter of the party name
    function registerParty(string calldata _partyName) external partyNumberDoesNotExceedCapacity {
        if (partyExists(_partyName)) {
            revert VotingContract__PartyNameAlreadyExists();
        }

        s_partyNameExists[_partyName] = true;
        PoliticalParty memory party = PoliticalParty({subjectName: _partyName, partyLeader: msg.sender, inCoalition: false, coalitionRequestsSent: 0});
        s_politicalParties[s_registrationNumber] = party;

        emit PoliticalPartyRegistered(s_registrationNumber++, _partyName, msg.sender);
    }

    // Možná udělat vytváření koalic ne podle adresy předsedy ale jména? Bude to víc gas-náročné thou
    function offerCoalition(string calldata _coalitionPartyName) external votingIsClosed coalitionNotYetRequested(_coalitionPartyName) {
        if (!partyExists(_coalitionPartyName)) {
            revert VotingContract__PartyNameDoesNotExist();
        }
        // msg.sender is the leader of the party
        // there is no request already
        // coalitionRequests is maximum 3
        // voting not started (MDF-1)
    }

    function withdrawCoalitionOffer(string calldata _coalitionPartyName) external votingIsClosed {
        // reuqest exists (MDF-2)
        // msg.sender is party leader
        // voting not started (MDF-1)
    }

    function acceptCoalition(string calldata _coalitionPartyName) external votingIsClosed {
        // request exists (MDF-2)
        // request is valid
        // can be accepted only by party leader
        // did not exceed the maximum of coalition members
        // 
        // voting not started (MDF-1)
    }

    function dismissCoalition() external votingIsClosed {
        // should require approval from all party owners
        // voting not started (MDF-1)
    }

    function removeFromCoalition(string calldata _coalitionPartyName) external votingIsClosed returns(bool) {
        // requires owners of all other parties
        // voting not started (MDF-1)
    }

    function leaveCoalition() external votingIsClosed {
        // voting not started (MDF-1)

    }

    function startElection() external {}

    function showVotingResults() external {}

    // #############################
    //      INTERNAL FUNCTIONS
    // #############################

    function partyExists(string memory _partyName) internal returns(bool) {
        bytes32 partyNameHash = bytes32(keccak256(abi.encodePacked(_partyName)));

        if (s_partyNameExists[partyNameHash]) {
            return true;
        }
        return false;
    }

    function _setupElection() internal {}

    function _calculateSeats() internal {}

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