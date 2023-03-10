// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract NftStaking is ERC721Holder {
    // Mapping of staked tokens to their expiration times
    mapping(uint256 => uint256) public stakedTokens;

    // Mapping of token IDs to their staking options
    mapping(uint256 => uint256) public stakingOptions;

    // The ERC20 token used for staking
    IERC20 public stakingToken;

    // The ERC721 token being staked
    IERC721 public nftToken;

    constructor() {
        stakingToken = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa); // address of the ERC20 token used for staking
        nftToken = IERC721(0x5FbDB2315678afecb367f032d93F642f64180aa3); // address of the ERC721 token being staked
    }

    // Stake an NFT for a specific period of time
    function stake(uint256 tokenId, uint256 duration) external {
        // Check that the caller is the owner of the token
        require(nftToken.ownerOf(tokenId) == msg.sender, "Not the owner");

        // Check that the token is not already staked
        require(stakedTokens[tokenId] == 0, "Already staked");

        // Check that the duration is valid
        require(duration == 7 days || duration == 14 days || duration == 21 days || duration == 28 days, "Invalid duration");

        // Calculate the staking option based on the duration
        uint256 stakingOption = duration / 7 days;

        // Get the current time
        uint256 currentTime = block.timestamp;

        // Calculate the expiration time
        uint256 expirationTime = currentTime + duration;

        // Transfer the NFT to this contract
        nftToken.safeTransferFrom(msg.sender, address(this), tokenId);

        // Approve the staking token for transfer
        stakingToken.approve(address(this), stakingOption);

        // Transfer the staking tokens to this contract
        stakingToken.transferFrom(msg.sender, address(this), stakingOption);

        // Update the staked token and staking option
        stakedTokens[tokenId] = expirationTime;
        stakingOptions[tokenId] = stakingOption;
    }

    // Claim an NFT that has been staked
    function claim(uint256 tokenId) external {
        // Check that the caller is the owner of the token
        require(nftToken.ownerOf(tokenId) == msg.sender, "Not the owner");

        // Check that the token is staked and has expired
        require(stakedTokens[tokenId] != 0, "Not staked");
        require(stakedTokens[tokenId] <= block.timestamp, "Not expired");

        // Calculate the staking reward
        uint256 reward = stakingOptions[tokenId] * 10**18;

        // Reset the staked token and staking option
      
        stakedTokens[tokenId] = 0;
        stakingOptions[tokenId] = 0;

        // Transfer the staking reward to the caller
        stakingToken.transfer(msg.sender, reward);

        // Transfer the  NFT to the caller
        nftToken.safeTransferFrom(address(this), msg.sender, tokenId);
    }
}
