/**
 * @type import('hardhat/config').HardhatUserConfig
 */

 require("@nomiclabs/hardhat-waffle");
 require('@nomiclabs/hardhat-ethers');
 
 
 const INFURA_URL = "";
 const PRIVATE_KEY = "";
 
 
 module.exports = {
   solidity: "0.8.0",
   /*
   networks: {
     rinkeby: {
       url: INFURA_URL,
       accounts: [`0x${PRIVATE_KEY}`],
       gas: 2100000,
       gasPrice: 8000000000
     }
   }
   */
 };
 
 