const hre = require('hardhat');
const { expect } = require("chai");
const assert = require("chai").assert;


describe("Two contract", () => {
    let Genesis, genesis, owner, addr1, addr2, provider;

    beforeEach(async () => {
        Genesis =  await ethers.getContractFactory("Two");
        [owner, addr1, addr2, _] = await ethers.getSigners();
        genesis = await Genesis.deploy("a");
        await genesis.deployed();
        //console.log(`LemonGenesis deployed to: ${genesis.address}`);
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
            await genesis.getYourOGLemmys(1);
            await genesis.transferFrom("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266", "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", 0);
            expect(await genesis.balanceOf("0x70997970C51812dc3A010C7d01b50e0d17dc79C8")).to.equal(1);
            await expect(genesis.getYourOGLemmys(1)).to.be.reverted;
        })

        // Tx Mint Limit
        it("owner will not be able to mint because exceeds the amount permited per tx", async function () {
            await expect(genesis.getYourOGLemmys(2)).to.be.reverted;
        })

        it("shouldnt let you mint because the contract is paused", async function () {
            await genesis.pause(true);
            await expect(genesis.getYourOGLemmys(1)).to.be.reverted;
        })
    })
/*
    describe("Change baseURI", () => {
        it("should change the baseURI", async function () {
            await genesis.setBaseURI("nanana");
            await expect(genesis._baseURI()).to.be.equal("nanana");
        })
    })
*/
})