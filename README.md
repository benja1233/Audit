# NFTs Audit

# Stack 
  - **Solidity**
  - **Hardhat**
  - **Ethers.js**
  - **Web3.js**


# File-description
Contracts => has all smart contracts. NFTOne is the NFTs contracts, NFTTwo is the other NFTs contract. 
             CurrencyToken is the ERC20 token contract.

Scripts => Contain two of the deploy Scripts files. The first one will deploy NFTOne and NFTTwo. The second script will deploy
           CurrencyToken contract. 

Test => test folder contains 2 tests. NFTOne test and NFTTwo test. 


# Background of the project:

## This project consists in the following
  **The first 2 contracts (NFTOne & NFTTwo) are contracts to mint NFTs**, the contract NFTOne will be the main contract to mint 10.000 NFTs and the Contract NFTTwo is to mint the second Generation of NFTs (yet to be decided when, but the Contract is finished). 

  **The contract NFTOne has more functionalities than the Contract NFTTwo:**
   This functionalities are the following:
   - **WhiteList Minting** and also WhiteListe Tx and Wallet maximun mint permited. 
   - **Reveal function** => Which allows to change the TokenURI to avoid trait snippig during the Mint Period.

  **The third contract (CurrencyToken)** is a contract for a ERC20 Token, This contract will be in charge of creating a token for the economics of a Game. The NFT holders will gain Tokens over time 
     - As you will notice, both Contracts One & Two have a "setLemonJuiceMachine()" function to connect to this contract throughout an Interface.
     - There is an override in contracts One and Two (transferFrom & safeTransferFrom) to add the function from the contract Three UpdateReward. This function is commented for running the test easier for contracts NFTOne and NFTTwo. 

# COMMANDS
## tests
    > npx hardhat test
## scripts
    > npx hardhat run scripts/deploy.js --network localhost 
    > npx hardhat run scripts/deployJuice.js --network localhost 
## compile 
    > npx hardhat compile

*Any questions regarding the functions or the files send an email to => benjisanchezlopez@gmail.com*