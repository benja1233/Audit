// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface iCurrency {
    function burn(address _from, uint256 _amount) external;

    function updateReward(address _from, address _to) external;
}

contract Two is ERC721Enumerable, Ownable {
    using Strings for uint256;

    // Strings
    string public baseURI;
    string public baseExtension = ".json";
    // Uint256
    uint256 public cost = 0.00 ether;
    uint256 public maxSupply = 200;
    uint256 public maxMintAmount = 1;
    uint256 public nftPerAddressLimit = 1;
    // Bool
    bool public paused = false;
    // Mappings
    mapping(address => uint256) public balanceOfTheChosenOne;

    // contract object
    iCurrency public Currency;

    // Contrusuctor
    constructor(string memory _initBaseURI) ERC721("TokenName", "TKN") {
    }

    // INTERNAL FUNCTIONS

    // @dev function returns the BaseURI
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    // PUBLIC FUNCTIONS

    // @dev function to mint an NFT
    // @param _mintAmount => Quantity to mint
    function getYourOGLemmys(uint256 _mintAmount) public payable {
        require(!paused, "the contract is paused");
        uint256 supply = totalSupply();
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        require(
            _mintAmount <= maxMintAmount,
            "max mint amount per session exceeded"
        );

        require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
        uint256 ownerMintedCount = balanceOfTheChosenOne[msg.sender];
        require(msg.value >= cost * _mintAmount, "insufficient funds");
        require(
            ownerMintedCount + _mintAmount <= nftPerAddressLimit,
            "max NFT per address exceeded"
        );

        for (uint256 i = 0; i < _mintAmount; i++) {
            balanceOfTheChosenOne[msg.sender]++;
            _safeMint(msg.sender, supply + i);
        }
    }

    // @dev Function that Burns your Lemmy. Everyone Owner of Lemmy can call this function and say "Sayonara Baby".
    // @param _tokenId => takes the parameter of your TokenId.
    function burnYourFriend(uint256 _tokenId) public returns (string memory) {
        require(ownerOf(_tokenId) == msg.sender, "You are not the owner");
        //Burn token
        _transfer(
            msg.sender,
            0x000000000000000000000000000000000000dEaD,
            _tokenId
        );
        //balanceOfTheChosenOne[msg.sender]--;
        return "You just burn your Lemmy Friend :( ";
    }

    // @dev Function that gives the amount of Lemmys that the Owner has.
    // @param _owner => takes the Owner Address.
    // @return the function returns an array of the tokenIDs that the Owners has.
    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    // @dev Function that sets the TokenURI for each tokenId
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    // Override functions of Transer and SafeTransfer
    function transferFrom(address from, address to, uint256 tokenId) public override {
        if (tokenId < maxSupply) {
            //Currency.updateReward(from, to);
            //balanceOfTheChosenOne[from]--;
            //balanceOfTheChosenOne[to]++;
        }
        ERC721.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override {
        if (tokenId < maxSupply) {
            //Currency.updateReward(from, to);
            //balanceOfTheChosenOne[from]--;
            //balanceOfTheChosenOne[to]++;
        }
        ERC721.safeTransferFrom(from, to, tokenId, data);
    }

    // ONLY OWNER FUNCTIONS

    function setLemonCurrencyMachine(address _CurrencyAddress) external onlyOwner {
        Currency = iCurrency(_CurrencyAddress);
    }

    // Set the limit to mint per address in whitelist
    function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
        nftPerAddressLimit = _limit;
    }

    // Set the cost of the product
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    // set the maximun amount of minting
    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    // Set the baseURI
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    // Set the base Extension, default => .json
    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    // Change the state of Pause => Cambiarlo para usar Pausable.sol de Openzeppelin
    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    // Withdraw all the eth inside the smart contract to the msg.sender address
    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }
}
