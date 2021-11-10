# NFTs Audit


## Repo Structure
### Contracts  
The project consists of two generation of NFTs (ERC-721) which will be created with contracts NFTOne.sol and NFTTwo.sol. CurrencyToken is an ERC20 contract which will mint a new token for the NFT holders, that will be used as an in-game currency

### Scripts 
Contain two deploy Scripts files. The first one will deploy NFTOne and NFTTwo. The second script will deploy CurrencyToken contract.

### Test 
test folder contains 2 tests. NFTOne test and NFTTwo test. 


# Background of the project

## This project consists in the following
  **The first 2 contracts (NFTOne & NFTTwo) are contracts to mint NFTs**, the contract NFTOne will be the main contract to mint 10.000 NFTs and the Contract NFTTwo will be used to mint the second Generation of NFTs (yet to be decided when, but the Contract is finished). NFTOne and CurrencyToken will be deployed at the same time, but the NFTTwo will be deployed later. 

  **The contract NFTOne has more functionalities than the Contract NFTTwo, because they will be available only for the first generation of NFTs**
   This functionalities are the following
   - **Whitelist Minting** 
   - **Whitelist Tx and Wallet maximun mint permitted.**
   - **Reveal function** => Which allows to change the TokenURI to avoid trait snippig during the Mint Period.
   - **Team Allocation** => This is an onlyOwner function used only once for the team to get their own NFTs for giveaways. 

  **The third contract (CurrencyToken)** is a contract for an ERC20 Token. This contract will be in charge of creating currency tokens for the holders of the NFTs that will be used in game. The NFT holders will gain Tokens over time, which will be used later. 
     - As you will notice, both Contracts One & Two have a "setLemonJuiceMachine()" function to connect to this contract throughout an Interface.
     - There is an override in contracts One and Two (transferFrom & safeTransferFrom) to add the function from the contract Three UpdateReward. This function is commented for running the test easier for contracts NFTOne and NFTTwo. 


# Stack 
  - **Solidity**
  - **Hardhat**
  - **Ethers.js**
  - **Web3.js**


# COMMANDS
## tests
    > npx hardhat test
## scripts
    > npx hardhat run scripts/deploy.js --network localhost 
    > npx hardhat run scripts/deployJuice.js --network localhost 
## compile 
    > npx hardhat compile

*Any questions regarding the functions or the files send an email to => benjisanchezlopez@gmail.com*

# Thank you :)