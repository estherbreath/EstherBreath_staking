// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Test, console2} from "forge-std/Test.sol";
import {EstherBreath} from "../src/Estherbreath_staking.sol";
contract EstherBreath_stakingTest is Test {
    EstherBreath public estherBreath;

     function setUp() public {
       estherBreath = new EstherBreath(address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2));
       
    }
function testValueGreaterThanZero() public {
    vm.expectRevert("Must stake ETH");
      estherBreath.stake(true);  
    } 

    function testStakingTimestampEqualZero() public {
        vm.expectRevert("Already staked");
        estherBreath.stake(true);
    }

    function testStakingAmountInWholeEther() public {
        vm.expectRevert("Stake amount must be in whole ETH units");
        estherBreath.stake(true);
    }

     function testCompoundRewardStakingTimestamp() public {
        vm.expectRevert("Not staked yet");
        estherBreath.compoundRewards();
    }

    function testAutoCompoundingNotEnabledForUser() public {
       vm.expectRevert("Auto-compound not enabled for the user");
        estherBreath.compoundRewards();
    }

        function testWithdrawalTimestampGreaterThanZero() public {
        vm.expectRevert("Not staked yet");
        estherBreath.withdraw();
    }

       function testGetAutoCompoundFee() public {
         vm.expectRevert();
        estherBreath.getAutoCompoundStatus(0x68B3BD05Cd59E5785C44DF452b045c50431ee8d1);
    }
    
}

