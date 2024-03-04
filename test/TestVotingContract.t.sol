// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.19;

import { Test, console } from "@forge-std/src/Test.sol";
import { DeployVotingContract } from "../script/DeployVotingContract.s.sol";
import { VotingContract } from "../src/VotingContract.sol";

contract TestVotingContract is Test {

    DeployVotingContract deployer;
    VotingContract vc;

    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");

    function setUp() public {
        deployer = new DeployVotingContract();
        vc = deployer.run();
    }

    // function testCanRegisterPolicitalParty() public {
    //     assertEq(vc.getNumberOfRegisteredParties(), 0);

    //     vm.startPrank(alice);
    //     vc.registerParty("ODS");
    //     vm.stopPrank();

    //     assertEq(vc.getNumberOfRegisteredParties(), 1);

    //     (,address leader,,) = vc.s_politicalParties(0);
    //     assertEq(leader, alice);
    // }

}