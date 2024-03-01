// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.19;

import { Script } from "@forge-std/src/Script.sol";
import { VotingContract } from "../src/VotingContract.sol";

contract DeployVotingContract is Script {

    function run() public returns(VotingContract) {
        VotingContract vc = new VotingContract();
        return vc;
    }

}