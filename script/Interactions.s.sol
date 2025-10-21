// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {CodeConstants} from "../script/DeployMyErc721.s.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {MyErc721} from "../src/MyErc721.sol";
import {Script} from "forge-std/Script.sol";

contract MintMyErc721 is Script, CodeConstants {
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "MyErc721",
            block.chainid
        );
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        MyErc721(contractAddress).mintNft(PUG);
        vm.stopBroadcast();
    }
}
