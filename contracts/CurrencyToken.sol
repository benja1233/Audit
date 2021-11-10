// SPDX-License-Identifier: MIT

// $JUICE

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

interface iLemonToken { 
  function balanceOf(address owner) external view returns (uint256);
}

interface iLemonGenesis {
  function balanceOf(address owner) external view returns (uint256);
}

contract Three is ERC20, Ownable, ERC20Burnable {
    // uint256
    uint256 public constant BASE_RATE = 3 ether;
    uint256 public constant BASE_RATE_OP = 6 ether;
    uint256 public START;
    // bool
    bool public pauseJuiceMachine = false;
    // mapping
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public lastUpdate;
    // address
    //address lemmysAddress;
    //address genesisAddress;

    iLemonToken public lemonToken;
    iLemonGenesis public lemonGenesis;

    constructor(address lemonTokenAddress) ERC20("TokenName", "TKN") {
        lemonToken = iLemonToken(lemonTokenAddress); // necesito el address del contract de LemonToken
        START = block.timestamp; // Arranca cuando se sube el contrato
    }

    // Updates rewards when transfering
    function updateReward(address from, address to) external {
        require(
            msg.sender == address(lemonToken) ||
                msg.sender == address(lemonGenesis)
        );
        if (from != address(0)) {
            rewards[from] += getPendingReward(from);
            lastUpdate[to] = block.timestamp;
        }
        if (to != address(0)) {
            rewards[to] += getPendingReward(from);
            lastUpdate[from] = block.timestamp;
        }
    }

    // Claim-Reward for the Nomrmal Collection
    function claimNormalReward() external {
        require(!pauseJuiceMachine, "Claiming reward has been paused");
        _mint(msg.sender, rewards[msg.sender] + getPendingReward(msg.sender));
        rewards[msg.sender] = 0;
        lastUpdate[msg.sender] = block.timestamp;
    }

    // Claim-Reward for the Genesis Collection
    function claimGenReward() external {
        require(!pauseJuiceMachine, "Claiming reward has been paused");
        _mint(
            msg.sender,
            rewards[msg.sender] + getPendingRewardGen(msg.sender)
        );
        rewards[msg.sender] = 0;
        lastUpdate[msg.sender] = block.timestamp;
    }

    // Internal functions for pending rewards => Both getPendingReward & getPendingRewardGen
    // Each function has a different Rate => BASE_RATE and BASE_RATE_OP
    function getPendingReward(address user) internal view returns (uint256) {
        return
            (lemonToken.balanceOf(user) *
                BASE_RATE *
                (block.timestamp -
                    (lastUpdate[user] >= START ? lastUpdate[user] : START))) /
            1;
    }

    function getPendingRewardGen(address user) internal view returns (uint256) {
        return
            (lemonGenesis.balanceOf(user) *
                BASE_RATE_OP *
                (block.timestamp -
                    (lastUpdate[user] >= START ? lastUpdate[user] : START))) /
            1;
    }

    // @dev function that will give the total amount that a user can Claim from the Normal Collection
    // @param the parameter is the user address
    function getTotalClaimableFromLemmys(address user)
        external
        view
        returns (uint256)
    {
        return rewards[user] + getPendingReward(user);
    }

    // @dev function that will give the total amount that a user can Claim from the Genesis Collection
    // @param the parameter is the user address
    function getTotalClaimableFromGenesis(address user)
        external
        view
        returns (uint256)
    {
        return rewards[user] + getPendingRewardGen(user);
    }

    // ToggleReward the $JUICE
    // Pause the production of tokens
    function toggleReward() public onlyOwner {
        pauseJuiceMachine = !pauseJuiceMachine;
    }

    // @dev function to set the contract address for the Genesis
    // @param the contract for Genesis
    /// Where are the Genesis? Nobody knows...
    function setGenContractAddress(address _newGenAddress) public onlyOwner {
        lemonGenesis = iLemonGenesis(_newGenAddress);
    }
}
