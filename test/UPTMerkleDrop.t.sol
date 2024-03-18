// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/UPTMerkleDrop.sol";
import "../src/Upto3Token.sol";
import "../src/PassCardNFT.sol";

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract TokenMerkleDropTest is Test {
    UPTMerkleDrop private drop;
    UPTToken private token;
    PassCardNFT private passCardNFT;

    address private owner = address(1);
    address private userWithPassCardNFT_211 =
        address(0x0000000000AD737A527C2757136aE83bB40b925e);
    address private userWithPassCardNFT_261 =
        address(0x0000000002C0FD34C64a4813d6568ABf13b0adDa);
    address private userWithoutPassCardNFT_38 =
        address(0x00000000051CBcE3fD04148CcE2c0adc7c651829);
    bytes32 private correctMerkleRoot =
        0xe1f1915abcd7a5438b961d529aed95ad5bb0b1bb3269d22a394cc41557275841;

    bytes32[] private correctProof_211 = [
        bytes32(
            0xb694fc72455891b4fc51734e1821d7b3b34aa29a75a00ce0906ba88ac75ba508
        ),
        bytes32(
            0x1b15ca6e4c5e5bab489982793b10371c1b95b3e138fff84db2a939cecd1ea076
        ),
        bytes32(
            0xf37ffac9bfbef1c2ddc4654e84e8ed62904d1e28dd756696005974315f28e9c6
        ),
        bytes32(
            0xfcbd5610c3f7f7f26aa8490c7842b216318139edf80d5145d3e0712358509155
        ),
        bytes32(
            0x659fe1e28ed22995e931e8666456a144cf029130bee9cdf05fc5f08ef51d8e08
        ),
        bytes32(
            0xca16cdfbc362e1daea0cdfea2f9641689b5ff0f1099e5ba1b8d9ce1cddf6fca0
        ),
        bytes32(
            0x6dd11568d8c28a655fd43e9b2351f3447c678bae2083aec1da14496d704c591b
        ),
        bytes32(
            0x23f817aea3f18f8723f4df6e68b7689cd584052fe54fbf032bc76f772bb15211
        ),
        bytes32(
            0xf424119b44aabd25b2d89c4c006dc30c7a42978bb1331ab5d66506076e0ae06f
        ),
        bytes32(
            0x585d109914e4a751ca35f11e98b7df0176c533f39bf038aaf6c1aeaefb64afd9
        ),
        bytes32(
            0x6a59e4af38a0f3a29d724af6c6e75c7ff5db75b40ba230d1bd66f3c4a49b8f71
        ),
        bytes32(
            0x00bf09482877b691d52608ab9564528786e31afb5c9d26957d52183b8b4ddab0
        ),
        bytes32(
            0xe1f6c2e8ecb0822d3783267200b9dfe89c80859d5f3ba5ec9e67494f8aab5fdb
        ),
        bytes32(
            0xcae8f576ecf335f433f8c04bcd949f1705311429d45bd58bffb058c8d0715a0c
        ),
        bytes32(
            0x8c6d35fffcb42bed6461aca6e93ea1968339188560745430a35d7faac43601e5
        ),
        bytes32(
            0x68012b9c989566145bbf4ea0b37b9920411e9ec0d4db2018429612faf7bb3430
        ),
        bytes32(
            0x79470b0078ce5b4057d10272e51f2d13153517f63c7e640cb49fa8764aa07474
        )
    ];

    bytes32[] private correctProof_261 = [
        bytes32(
            0x3afb554d72d7f838c76dbfae211162a2939f72b8349a3123e42df397a512dab3
        ),
        bytes32(
            0x1b15ca6e4c5e5bab489982793b10371c1b95b3e138fff84db2a939cecd1ea076
        ),
        bytes32(
            0xf37ffac9bfbef1c2ddc4654e84e8ed62904d1e28dd756696005974315f28e9c6
        ),
        bytes32(
            0xfcbd5610c3f7f7f26aa8490c7842b216318139edf80d5145d3e0712358509155
        ),
        bytes32(
            0x659fe1e28ed22995e931e8666456a144cf029130bee9cdf05fc5f08ef51d8e08
        ),
        bytes32(
            0xca16cdfbc362e1daea0cdfea2f9641689b5ff0f1099e5ba1b8d9ce1cddf6fca0
        ),
        bytes32(
            0x6dd11568d8c28a655fd43e9b2351f3447c678bae2083aec1da14496d704c591b
        ),
        bytes32(
            0x23f817aea3f18f8723f4df6e68b7689cd584052fe54fbf032bc76f772bb15211
        ),
        bytes32(
            0xf424119b44aabd25b2d89c4c006dc30c7a42978bb1331ab5d66506076e0ae06f
        ),
        bytes32(
            0x585d109914e4a751ca35f11e98b7df0176c533f39bf038aaf6c1aeaefb64afd9
        ),
        bytes32(
            0x6a59e4af38a0f3a29d724af6c6e75c7ff5db75b40ba230d1bd66f3c4a49b8f71
        ),
        bytes32(
            0x00bf09482877b691d52608ab9564528786e31afb5c9d26957d52183b8b4ddab0
        ),
        bytes32(
            0xe1f6c2e8ecb0822d3783267200b9dfe89c80859d5f3ba5ec9e67494f8aab5fdb
        ),
        bytes32(
            0xcae8f576ecf335f433f8c04bcd949f1705311429d45bd58bffb058c8d0715a0c
        ),
        bytes32(
            0x8c6d35fffcb42bed6461aca6e93ea1968339188560745430a35d7faac43601e5
        ),
        bytes32(
            0x68012b9c989566145bbf4ea0b37b9920411e9ec0d4db2018429612faf7bb3430
        ),
        bytes32(
            0x79470b0078ce5b4057d10272e51f2d13153517f63c7e640cb49fa8764aa07474
        )
    ];

    bytes32[] private correctProof_38 = [
        bytes32(
            0x8cb27477526e637d174ad296f205d9a1eb775a447f369a77a845d8a8a1792974
        ),
        bytes32(
            0x75d1969a4a1f766502ad84722779712d7b6c30c8daf1aa2579bae8f72c9e7843
        ),
        bytes32(
            0xf37ffac9bfbef1c2ddc4654e84e8ed62904d1e28dd756696005974315f28e9c6
        ),
        bytes32(
            0xfcbd5610c3f7f7f26aa8490c7842b216318139edf80d5145d3e0712358509155
        ),
        bytes32(
            0x659fe1e28ed22995e931e8666456a144cf029130bee9cdf05fc5f08ef51d8e08
        ),
        bytes32(
            0xca16cdfbc362e1daea0cdfea2f9641689b5ff0f1099e5ba1b8d9ce1cddf6fca0
        ),
        bytes32(
            0x6dd11568d8c28a655fd43e9b2351f3447c678bae2083aec1da14496d704c591b
        ),
        bytes32(
            0x23f817aea3f18f8723f4df6e68b7689cd584052fe54fbf032bc76f772bb15211
        ),
        bytes32(
            0xf424119b44aabd25b2d89c4c006dc30c7a42978bb1331ab5d66506076e0ae06f
        ),
        bytes32(
            0x585d109914e4a751ca35f11e98b7df0176c533f39bf038aaf6c1aeaefb64afd9
        ),
        bytes32(
            0x6a59e4af38a0f3a29d724af6c6e75c7ff5db75b40ba230d1bd66f3c4a49b8f71
        ),
        bytes32(
            0x00bf09482877b691d52608ab9564528786e31afb5c9d26957d52183b8b4ddab0
        ),
        bytes32(
            0xe1f6c2e8ecb0822d3783267200b9dfe89c80859d5f3ba5ec9e67494f8aab5fdb
        ),
        bytes32(
            0xcae8f576ecf335f433f8c04bcd949f1705311429d45bd58bffb058c8d0715a0c
        ),
        bytes32(
            0x8c6d35fffcb42bed6461aca6e93ea1968339188560745430a35d7faac43601e5
        ),
        bytes32(
            0x68012b9c989566145bbf4ea0b37b9920411e9ec0d4db2018429612faf7bb3430
        ),
        bytes32(
            0x79470b0078ce5b4057d10272e51f2d13153517f63c7e640cb49fa8764aa07474
        )
    ];

    ERC1967Proxy public proxy;
    UPTMerkleDrop public impl;
    bytes public data;

    function setUp() public {
        vm.startPrank(owner);

        token = new UPTToken(100_000_000e18);
        passCardNFT = new PassCardNFT();

        // drop = new UPTMerkleDrop();
        // drop.initialize(address(token), address(passCardNFT));

        data = abi.encodeWithSignature(
            "initialize(address,address)",
            address(token),
            address(passCardNFT)
        );
        impl = new UPTMerkleDrop();
        proxy = new ERC1967Proxy(address(impl), data);

        // proxy._implementation().setMerkleRoot(correctMerkleRoot);
        address(proxy).delegatecall(
            abi.encodeWithSignature("setMerkleRoot(bytes32)", correctMerkleRoot)
        );

        token.transfer(address(proxy), 212e18);

        vm.stopPrank();

        vm.startPrank(userWithPassCardNFT_211);
        passCardNFT.mint();
        vm.stopPrank();

        vm.startPrank(userWithPassCardNFT_261);
        passCardNFT.mint();
        vm.stopPrank();
    }

    function test_claim() public {
        vm.startPrank(userWithPassCardNFT_211);

        // proxy._implementation().claim(211e18, correctProof_211);
        address(proxy).delegatecall(
            abi.encodeWithSignature(
                "claim(uint256,bytes32[])",
                211e18,
                correctProof_211
            )
        );

        drop.claim(211e18, correctProof_211);

        assertEq(
            token.balanceOf(userWithPassCardNFT_211),
            211e18,
            "User should have received token"
        );
        // assertTrue(
        //     // proxy._implementation().hasClaimed(userWithPassCardNFT_211),
        //     address(proxy).delegatecall(
        //         abi.encodeWithSignature(
        //             "hasClaimed(address)",
        //             userWithPassCardNFT_211
        //         )
        //     ),
        //     "Claim flag should be true for user"
        // );

        // vm.stopPrank();
    }

    // function test_wrongAmountClaim() public {
    //     vm.startPrank(userWithPassCardNFT_211);

    //     vm.expectRevert(bytes("TokenMerkleDrop: Invalid proof."));
    //     proxy._implementation().claim(212e18, correctProof_211);

    //     vm.stopPrank();
    // }

    // function test_alreadyClaimed() public {
    //     vm.startPrank(userWithPassCardNFT_211);

    //     proxy._implementation().claim(211e18, correctProof_211);
    //     assertTrue(
    //         proxy._implementation().hasClaimed(userWithPassCardNFT_211),
    //         "Claim flag should be true for user"
    //     );

    //     vm.expectRevert(bytes("TokenMerkleDrop: Drop already claimed."));
    //     proxy._implementation().claim(211e18, correctProof_211);

    //     vm.stopPrank();
    // }

    // function test_withoutPassCardNFT() public {
    //     vm.startPrank(userWithoutPassCardNFT_38);

    //     vm.expectRevert(
    //         bytes("TokenMerkleDrop: Must own at least one Pass Card NFT.")
    //     );
    //     proxy._implementation().claim(38e18, correctProof_38);

    //     vm.stopPrank();
    // }

    // function test_claimWrongProof() public {
    //     vm.startPrank(userWithPassCardNFT_211);

    //     bytes32[] memory wrongProof = new bytes32[](1);
    //     wrongProof[0] = 0x0;

    //     vm.expectRevert(bytes("TokenMerkleDrop: Invalid proof."));
    //     proxy._implementation().claim(211e18, wrongProof);

    //     vm.stopPrank();
    // }

    // function test_insufficientBalance() public {
    //     vm.startPrank(userWithPassCardNFT_261);

    //     bytes memory encodedError = abi.encodeWithSignature(
    //         "ERC20InsufficientBalance(address,uint256,uint256)",
    //         address(proxy),
    //         212e18,
    //         261e18
    //     );
    //     vm.expectRevert(encodedError);
    //     proxy._implementation().claim(261e18, correctProof_261);

    //     vm.stopPrank();
    // }

    // function teste_updateMerkleRoot() public {
    //     vm.startPrank(owner);

    //     proxy._implementation().setMerkleRoot(0x0);
    //     assertEq(
    //         proxy._implementation().merkleRoot(),
    //         0x0,
    //         "Merkle root should have been updated"
    //     );

    //     vm.stopPrank();
    // }

    // function test_updateMerkleRootNotOwner() public {
    //     vm.startPrank(userWithPassCardNFT_211);
    //     bytes memory encodedError = abi.encodeWithSignature(
    //         "OwnableUnauthorizedAccount(address)",
    //         userWithPassCardNFT_211
    //     );
    //     vm.expectRevert(encodedError);
    //     proxy._implementation().setMerkleRoot(0x0);

    //     vm.stopPrank();
    // }

    // function test_pauseAndUnpause() public {
    //     vm.startPrank(owner);
    //     proxy._implementation().pause();
    //     assertTrue(
    //         proxy._implementation().paused(),
    //         "Contract should be paused"
    //     );

    //     proxy._implementation().unpause();
    //     assertFalse(
    //         proxy._implementation().paused(),
    //         "Contract should be unpaused"
    //     );
    //     vm.stopPrank();
    // }

    // function test_pauseAndUnpauseNotOwner() public {
    //     vm.startPrank(userWithPassCardNFT_211);
    //     bytes memory encodedError = abi.encodeWithSignature(
    //         "OwnableUnauthorizedAccount(address)",
    //         userWithPassCardNFT_211
    //     );
    //     vm.expectRevert(encodedError);
    //     proxy._implementation().pause();
    //     vm.stopPrank();

    //     vm.startPrank(owner);
    //     proxy._implementation().pause();
    //     vm.stopPrank();

    //     vm.startPrank(userWithPassCardNFT_211);
    //     vm.expectRevert(encodedError);
    //     proxy._implementation().unpause();
    //     vm.stopPrank();
    // }

    // function test_withdrawTokens() public {
    //     assertEq(
    //         token.balanceOf(owner),
    //         99_999_788e18,
    //         "Owner should have 99,999,788 tokens"
    //     );

    //     vm.startPrank(owner);
    //     proxy._implementation().pause();
    //     proxy._implementation().withdrawTokens(owner);
    //     assertEq(
    //         token.balanceOf(owner),
    //         100_000_000e18,
    //         "Owner should have withdrawn all tokens"
    //     );
    //     vm.stopPrank();
    // }

    // function test_withdrawTokensNotPaused() public {
    //     vm.startPrank(owner);
    //     vm.expectRevert(bytes("TokenMerkleDrop: Contract is not paused."));
    //     proxy._implementation().withdrawTokens(owner);
    //     vm.stopPrank();
    // }

    // function test_withdrawTokensNotOwner() public {
    //     vm.startPrank(owner);
    //     proxy._implementation().pause();
    //     vm.stopPrank();

    //     vm.startPrank(userWithPassCardNFT_211);
    //     bytes memory encodedError = abi.encodeWithSignature(
    //         "OwnableUnauthorizedAccount(address)",
    //         userWithPassCardNFT_211
    //     );
    //     vm.expectRevert(encodedError);
    //     proxy._implementation().withdrawTokens(owner);
    //     vm.stopPrank();
    // }
}
