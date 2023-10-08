// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./IERC20.sol";

contract EstherBreath  is ERC20, Ownable {
       using SafeERC20 for IERC20;

    uint256 public constant APR = 14; // Annual Percentage Rate
    uint256 public constant REWARD_RATIO = 10; // 1:10 ratio to ETH for reward
    uint256 public constant COMPOUNDING_RATE = 1; // 1% auto compounding rate
    uint256 public constant SECONDS_IN_MONTH = 2592000; // 30 days assuming 30 days per month


    IERC20 public weth; // Wrapped Ether contract

    uint256 public lastCompoundTimestamp;
    uint256 public autoCompoundFee;
    uint256 public totalAutoCompoundRewards;

    mapping(address => uint256) public stakingTimestamp;
    mapping(address => bool) public autoCompounding;

    event AutoCompoundEnabled(address indexed user);
    event AutoCompoundDisabled(address indexed user);

    constructor(address _weth) ERC20("EstherBreath", "EBT") {
        weth = IERC20(_weth);
    }

    function stake(bool _autoCompound) external payable {
        require(msg.value > 0, "Must stake ETH");
        require(stakingTimestamp[msg.sender] == 0, "Already staked");
        require(msg.value % 1 ether == 0, "Stake amount must be in whole ETH units");

        uint256 wethAmount = msg.value * REWARD_RATIO;
        uint256 feeAmount = (msg.value * COMPOUNDING_RATE) / 100;

        // Convert ETH to WETH and store in the contract
        weth.safeTransferFrom(msg.sender, address(this), msg.value);
        _mint(msg.sender, wethAmount - feeAmount);

        // Store the staking timestamp for the user
        stakingTimestamp[msg.sender] = block.timestamp;
        autoCompounding[msg.sender] = _autoCompound;

        // Update the auto compound fee
        autoCompoundFee += feeAmount;

        if (_autoCompound) {
            emit AutoCompoundEnabled(msg.sender);
        }
    }

    function calculateReward(address user) internal view returns (uint256) {
        require(stakingTimestamp[user] > 0, "User has not staked yet");
        uint256 timeElapsed = block.timestamp - stakingTimestamp[user];
        uint256 rewardPerSecond = (APR * REWARD_RATIO) / (SECONDS_IN_MONTH * 100);
        return rewardPerSecond * timeElapsed;
    }

    function compoundRewards() external {
        require(stakingTimestamp[msg.sender] > 0, "Not staked yet");
        require(autoCompounding[msg.sender], "Auto-compound not enabled for the user");

        uint256 earnedRewards = calculateReward(msg.sender);
        require(earnedRewards > 0, "No rewards to compound");

        // Mint new tokens to the depositor (excluding the fee)
        _mint(msg.sender, earnedRewards);

        // Update the last compound timestamp
        lastCompoundTimestamp = block.timestamp;

        // Deduct the auto compound fee
        uint256 feeAmount = (earnedRewards * COMPOUNDING_RATE) / 100;
        totalAutoCompoundRewards += feeAmount;
        autoCompoundFee -= feeAmount;
    }

    function withdraw() external {
        require(stakingTimestamp[msg.sender] > 0, "Not staked yet");

        uint256 rewardAmount = calculateReward(msg.sender);

        // Convert rewards to WETH and transfer to the user
        uint256 wethReward = rewardAmount / REWARD_RATIO;
        weth.safeTransfer(msg.sender, wethReward);

        // Burn tokens from the user's balance
        _burn(msg.sender, rewardAmount);

        // Update the last compound timestamp
        lastCompoundTimestamp = block.timestamp;

        // Reset staking timestamp for the user
        stakingTimestamp[msg.sender] = 0;
        autoCompounding[msg.sender] = false;
        emit AutoCompoundDisabled(msg.sender);
    }

    function getAutoCompoundFee() external view returns (uint256) {
        return autoCompoundFee;
    }

    function getAutoCompoundStatus(address user) external view returns (bool) {
        return autoCompounding[user];
    }
}


