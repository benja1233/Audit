const hre = require('hardhat');
const { expect } = require("chai");
const assert = require("chai").assert;


describe("Two contract", () => {
    let Genesis, genesis, owner, addr1, addr2, provider;
    const ownerAddress = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";
    const guestAddress = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8";

    beforeEach(async () => {
        Genesis =  await ethers.getContractFactory("Two");
        [owner, addr1, addr2, _] = await ethers.getSigners();
        genesis = await Genesis.deploy("a");
        await genesis.deployed();
        //console.log(`NFTTwo deployed to: ${genesis.address}`);
        //console.log(owner.address);
        //console.log(addr1.address);
    })
    
    describe('Deployment', () => {
      it('should set the right owner', async function () {
        expect(await genesis.owner()).to.equal(owner.address);
      });
    });

    describe("Mint", () => {
        // Wallet Mint Limit 
        it("owner will not be able to mint because exceeds the amount permited per wallet", async function () {
            await genesis.getYourOGNFTs(1);
            await genesis.transferFrom(ownerAddress, guestAddress, 0);
            expect(await genesis.balanceOf(guestAddress)).to.equal(1);
            await expect(genesis.getYourOGNFTs(1)).to.be.reverted;
        })

        // Tx Mint Limit
        it("owner will not be able to mint because exceeds the amount permited per tx", async function () {
            await expect(genesis.getYourOGNFTs(2)).to.be.reverted;
        })

        it("shouldnt let you mint because the contract is paused", async function () {
            await genesis.pause(true);
            await expect(genesis.getYourOGNFTs(1)).to.be.reverted;
        })
    })

})