const hre = require('hardhat');
const { expect } = require("chai");
const assert = require("chai").assert;


describe("One contract", () => {
    let Token, token, owner, addr1, addr2, provider;
    let ownerAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    let guestAddress = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    beforeEach(async () => {
        Token =  await ethers.getContractFactory("One");
        [owner, addr1, addr2, _] = await ethers.getSigners();
        token = await Token.deploy("h", "f");
        await token.deployed();
        //console.log(`NFTOne deployed to: ${token.address}`);
        //console.log(owner.address);
        //console.log(addr1.address);
    })
    

    describe('Deployment', () => {
      it('should set the right owner', async function () {
        expect(await token.owner()).to.equal(owner.address);
      });
    });

    describe("whiteListing Addresses", () => {
      it("should White List and Address", async function () {
        await token.whitelistUsers(["0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"]);
        expect(await token.isWhitelisted("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")).to.equal(true);
      })
    })

    describe("Mint", () => {

      // Paused
      it("shouldnt let you mint because the contract is paused", async function () {
        await token.pause(true);
        await expect(token.mint(1)).to.be.reverted;
      })


      // WL test
      it("owner will be able to mint because is whiteListed is false", async function () {
        await token.setOnlyWhitelisted(false);
        await token.mint(1); // mint for owner
        expect(await token.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")).to.equal(1);
      });
      // WL test
      it("owner will be able to mint because is whiteListed", async function () {
        await token.whitelistUsers(["0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"]);
        await token.mint(1); // mint for owner
        expect(await token.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")).to.equal(1);
      })
      // Wl test
      it("owner will not be able to mint because is not WL", async function () {
        await expect(token.mint(1)).to.be.reverted;
      })

      // Wallet Mint Limit (WL false)
      it("owner will not be able to mint because exceeds the amount permited per wallet", async function () {
        await token.setOnlyWhitelisted(false);
        await token.mint(1);
        await token.transferFrom("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266", "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", 0);
        expect(await token.balanceOf("0x70997970C51812dc3A010C7d01b50e0d17dc79C8")).to.equal(1);
        await expect(token.mint(1)).to.be.reverted;
      })

      // Tx Mint Limit (WL false)
      it("owner will not be able to mint because exceeds the amount permited per tx", async function () {
        await token.setOnlyWhitelisted(false);
        await expect(token.mint(2)).to.be.reverted;
      })

      // Tx Mint Limit (Wl true)
      it("owner will not be able to mint because exceeds the amount permited per tx during WhiteList", async function () {
        await token.whitelistUsers(["0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"]);
        await expect(token.mint(2)).to.be.reverted;
      })

      // Tx Mint Limit (WL true)
      it("owner will not be able to mint because exceeds the amount permited per wallet during WhiteList", async function () {
        await token.whitelistUsers(["0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"]);
        await token.mint(1);
        await token.transferFrom("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266", "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", 0);
        expect(await token.balanceOf("0x70997970C51812dc3A010C7d01b50e0d17dc79C8")).to.equal(1);
        await expect(token.mint(1)).to.be.reverted;
      })

    });

    // Burning and minting Test
    describe("Bruning a NFT", () => {
      it("should burn a NFT and then when trying to mint it shouldnt let you", async function () {
        await token.whitelistUsers(["0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"]);
        await token.mint(1);
        expect(await token.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")).to.equal(1);
        await token.burnYourFriend(0);
        expect(await token.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")).to.equal(0);
        await expect(token.mint(1)).to.be.reverted;
      })
    })

})