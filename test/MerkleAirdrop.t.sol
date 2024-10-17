//SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;

import {Test,console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {GNXToken} from "../src/GNXToken.sol";
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
import {DeployMerkleAirdrop} from "script/DeployMerkleAirdrop.s.sol";

contract MerkleAirdropTest is ZkSyncChainChecker,Test{

    MerkleAirdrop public airdrop;
    GNXToken public token;

    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 public constant AMOUNT=25*1e18; //eq. to amountToCollect
    uint256 public AMOUNT_TO_SEND=AMOUNT*4;
    bytes32 proofOne=0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo=0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    // bytes32 proofThree=0x4fd31fee0e75780cd67704fbc43caee70fddcaa43631e2e1bc9fb233fada2394;
    bytes32[] public PROOF=[proofOne,proofTwo]; 
    address user;
    address gasPayer;
    uint256 userPrivKey;

    function setUp()public{
        if(!isZkSyncChain()){
            DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
            (airdrop,token) = deployer.deployMerkleAirdrop();
        }
        else{
        gasPayer= makeAddr("gasPayer");
        token = new GNXToken();
        airdrop = new MerkleAirdrop(ROOT,token);

        token.mint(token.owner(),AMOUNT_TO_SEND);
        token.transfer(address(airdrop),AMOUNT_TO_SEND);
    }
    (user,userPrivKey)=makeAddrAndKey("user");
    }

    function signMessage(uint256 privKey, address account) public view returns(uint8 v, bytes32 r, bytes32 s){
        bytes32 hashedMessage = airdrop.getMessageHash(account,AMOUNT);
        (v,r,s)=vm.sign(privKey,hashedMessage);

    }
    function testUsersCanClaim() public{
        uint256 startingBalance=token.balanceOf(user);
        vm.startPrank(user);
        (uint8 v, bytes32 r, bytes32 s)= signMessage(userPrivKey,user);
        vm.stopPrank();
        vm.prank(gasPayer);
        airdrop.claim(user,AMOUNT,PROOF,v,r,s);
        uint256 endingBalance=token.balanceOf(user);
        console.log("Ending Balance: %d",endingBalance);
        assertEq(endingBalance-startingBalance,AMOUNT);
    }

}