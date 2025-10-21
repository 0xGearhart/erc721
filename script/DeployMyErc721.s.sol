// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {MyErc721} from "../src/MyErc721.sol";
import {Script} from "forge-std/Script.sol";

contract CodeConstants {
    string constant NFT_NAME = "MyNft";
    string constant NFT_SYMBOL = "MN";
    uint256 constant MAX_SUPPLY = 100;
    string constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
}

contract DeployMyErc721 is CodeConstants, Script {
    function run() external returns (MyErc721) {
        vm.startBroadcast();
        MyErc721 myErc721 = new MyErc721(NFT_NAME, NFT_SYMBOL, MAX_SUPPLY);
        vm.stopBroadcast();
        return myErc721;
    }
}
