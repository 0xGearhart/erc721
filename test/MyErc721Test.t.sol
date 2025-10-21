// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployMyErc721, CodeConstants} from "../script/DeployMyErc721.s.sol";
import {MyErc721} from "../src/MyErc721.sol";
import {Test} from "forge-std/Test.sol";

contract MyErc721Test is CodeConstants, Test {
    DeployMyErc721 public deployer;
    MyErc721 public myErc721;

    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

    function setUp() external {
        deployer = new DeployMyErc721();
        myErc721 = deployer.run();
    }

    function testCurrentSupplyIsSetToZeroAtDeployment() external view {
        assertEq(myErc721.getCurrentSupply(), 0);
    }

    function testMaxSupplyWasSetCorrectly() external view {
        assertEq(myErc721.getMaxSupply(), MAX_SUPPLY);
    }

    function testNameWasSetCorrectly() external view {
        // cannot directly compare two strings with assert(myErc721.name() == NFT_NAME);
        // since strings are actually arrays they need to be encoded and hashed so we can compare the hash of the values inside the array
        assert(
            keccak256(abi.encodePacked(myErc721.name())) ==
                keccak256(abi.encodePacked(NFT_NAME))
        );
        // this cleaner method works as well
        assertEq(myErc721.name(), NFT_NAME);
    }

    function testSymbolWasSetCorrectly() external view {
        assertEq(myErc721.symbol(), NFT_SYMBOL);
    }

    function testUriIsSetCorrectlyDuringMint() external {
        uint256 nftId = 1;
        vm.prank(user1);
        myErc721.mintNft(PUG);

        assertEq(myErc721.tokenURI(nftId), PUG);
    }

    function testMintAndBalanceWorksCorrectly() external {
        uint256 nftId = 1;
        uint256 expectedBalance = 1;
        vm.prank(user1);
        myErc721.mintNft(PUG);

        assertEq(myErc721.balanceOf(user1), expectedBalance);
        assert(myErc721.ownerOf(nftId) == user1);
    }

    function testMintRevertsWhenMaxSupplyIsExceeded() external {
        string memory dummyUri = "NFT";
        for (uint i = 1; i <= MAX_SUPPLY; i++) {
            address currentUser = address(uint160(i));
            vm.prank(currentUser);
            myErc721.mintNft(dummyUri);
        }
        assertEq(myErc721.getCurrentSupply(), MAX_SUPPLY);

        vm.prank(user1);
        vm.expectRevert(MyErc721.MyErc721__MaxSupplyExceeded.selector);
        myErc721.mintNft(dummyUri);
    }
}
