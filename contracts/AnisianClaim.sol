// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IAnisian {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
}

contract AnisianClaim {
    IAnisian public token;
    address public lpPool;
    uint256 public claimAmount;
    uint256 public totalClaimed;
    address public owner;
    mapping(address => bool) public hasClaimed;

    event Claimed(address indexed user, uint256 amount);

    constructor(address _token, address _lpPool, uint256 _claimAmount) {
        token = IAnisian(_token);
        lpPool = _lpPool;
        claimAmount = _claimAmount;
        owner = msg.sender;
    }

    function claim() external {
        require(!hasClaimed[msg.sender], "Already claimed");
        require(token.balanceOf(address(this)) >= claimAmount, "No ANI left");
        hasClaimed[msg.sender] = true;
        totalClaimed += claimAmount;
        require(token.transfer(msg.sender, claimAmount), "Transfer failed");
        emit Claimed(msg.sender, claimAmount);
    }
}
