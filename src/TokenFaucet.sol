// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract TokenFaucet {

    IERC20 public token;
    uint256 public tokenAmount;
    uint256 public cooldownTime;
    mapping (address => uint) public lastClaimTime;
    event TokenDispensed(address indexed user, uint256 amount);

    constructor(address _tokenAddress, uint256 _tokenAmount, uint256 _timeCooldown) {
        token = IERC20(_tokenAddress);
        tokenAmount = _tokenAmount;
        cooldownTime = _timeCooldown;
    }

    function requestToken() external {
        require(block.timestamp >= lastClaimTime[msg.sender] + cooldownTime, "Cooldown period now over");

        lastClaimTime[msg.sender] = block.timestamp;

        token.transfer(msg.sender, tokenAmount);

        emit TokenDispensed(msg.sender, tokenAmount);
    }

}