// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Test, console2} from "forge-std/Test.sol";
import {EstherBreath_stakingTest} from "../src/Estherbreath_staking.sol";
contract EstherBreath_stakingTest is Test {
    EstherBreath_staking public estherBreath_staking;

     function setUp() public {
       estherBreath_staking = new EstherBreath_staking();
        
    }
}