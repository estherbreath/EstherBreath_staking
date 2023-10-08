// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardToken is ERC20 {
        constructor(
        string memory _name,
        string memory _symbol,
        uint256 _amount,
        address EstherBreath
    ) ERC20(_name, _symbol) {
        _mint(EstherBreath, _ammount);
    }

}