NFT STAKE:

The NftStaking contract allows users to stake their ERC721 NFTs for a specified duration and receive ERC20 token rewards when the stake expires. The contract implements the ERC721Holder interface to enable safe transfer of NFTs to and from the contract.

The contract has a constructor that takes two arguments: an IERC721 contract instance for the NFT token and an IERC20 contract instance for the rewards token. These contracts are stored as state variables nftToken and erc20Token, respectively.

The stake() function takes two arguments: the ID of the NFT to stake and the duration of the stake. The duration must be one of four possible values: 7 days, 14 days, 21 days, or 28 days. The function checks that the caller is the owner of the NFT, that the NFT is not already staked, and that the duration is valid. If these checks pass, the function transfers the NFT to the contract, calculates the expiration time, stores it in the stakedTokens mapping, and emits an event to indicate that the NFT was staked.

The unstake() function takes one argument: the ID of the NFT to unstake. The function checks that the NFT is currently staked and that the stake has expired. If these checks pass, the function calculates the reward amount based on the duration of the stake, transfers the rewards to the staker, transfers the NFT back to the staker, resets the expiration time in the stakedTokens mapping, and emits an event to indicate that the NFT was unstaked.

The getRewardAmount() function takes one argument: the ID of the NFT. The function returns the reward amount that the staker will receive when the NFT is unstaked, based on the duration of the stake. The reward amount is calculated using a simple if-else statement that checks the duration of the stake and returns a corresponding reward amount.instance for the NFT token and an IERC20 contract instance for the rewards token. These contracts are stored as state variables nftToken and erc20Token, respectively.

The contract has a mapping stakedTokens that associates each staked token ID with the expiration time of the stake. When a user stakes an NFT, the contract transfers the NFT to itself and stores the expiration time in this mapping. When the stake expires, the user can unstake the NFT and claim the rewards by calling the unstake() fun

