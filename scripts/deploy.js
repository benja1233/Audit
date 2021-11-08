const fs = require('fs');

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log(`Deploying contracts with the account: ${deployer.address}`);
  
  const balance = await deployer.getBalance();
  console.log(`Account balance: ${balance.toString()}`);

  const Token = await ethers.getContractFactory('One');
  const token = await Token.deploy("h","g");
  console.log(`Token address: ${token.address}`);

  const data = {
    address: token.address,
    abi: JSON.parse(token.interface.format('json'))
  };
  //fs.writeFileSync('src/One.json', JSON.stringify(data)); 


  const Token2 = await ethers.getContractFactory('Two');
  const token2 = await Token2.deploy("a");
  console.log(`Token address: ${token2.address}`);

  const data2 = {
    address: token2.address,
    abi: JSON.parse(token2.interface.format('json'))
  };
  //fs.writeFileSync('src/Two.json', JSON.stringify(data2)); 
}


main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
