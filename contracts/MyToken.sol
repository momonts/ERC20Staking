// SPDX-License-Identifier: UNLICENSE

pragma solidity >=0.8.0 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    mapping(address => uint256) private _stake;
    mapping(address => uint256) private _lastStakeTime;
    uint256 private rewardRate = 10;

    constructor()
        ERC20("MyToken", "MTK")
        Ownable(0xDE90CA19F22Bd7f852Cd9fa15aa4A9820b90211A)
    {
        _mint(msg.sender, 1000 * 10 ** 18);
    }

    modifier timeLock() {
        require(
            block.timestamp - _lastStakeTime[msg.sender] >= 1 minutes,
            "Time lock not expired"
        );
        _;
    }

    modifier validAmount(uint256 amount) {
        require(amount > 0, "Amount cannot be 0");
        _;
    }

    function mint(uint256 amount) public onlyOwner {
        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) public onlyOwner {
        _burn(msg.sender, amount);
    }

    function staking(uint256 amount) public validAmount(amount) {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        _stake[msg.sender] += amount;
        _lastStakeTime[msg.sender] = block.timestamp;
        _transfer(msg.sender, address(this), amount);
    }

    function unstake(uint256 amount) public timeLock validAmount(amount) {
        require(amount <= _stake[msg.sender], "Insufficient stake");

        uint256 reward = (((block.timestamp - _lastStakeTime[msg.sender]) /
            1 minutes) * rewardRate) * _stake[msg.sender];

        _stake[msg.sender] -= amount;
        _mint(msg.sender, reward);
        _transfer(address(this), msg.sender, amount);
    }

    function getCurrentStake(address account) public view returns (uint256) {
        return _stake[account];
    }

    function getCurrentRewards(address account) public view returns (uint256) {
        uint256 reward = (((block.timestamp - _lastStakeTime[account]) /
            1 minutes) * rewardRate) * _stake[account];
        return reward;
    }
}
