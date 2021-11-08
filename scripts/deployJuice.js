const fs = require('fs');

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log(`Deploying contracts with the account: ${deployer.address}`);
  
  const balance = await deployer.getBalance();
  console.log(`Account balance: ${balance.toString()}`);

  const Token = await ethers.getContractFactory('Juice');
  const token = await Token.deploy("0x5FbDB2315678afecb367f032d93F642f64180aa3");
  console.log(`Token address: ${token.address}`);

  const data = {
    address: token.address,
    abi: JSON.parse(token.interface.format('json'))
  };
  fs.writeFileSync('src/Juice.json', JSON.stringify(data)); 
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
