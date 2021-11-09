// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


interface IJuice {
    function burn(address _from, uint256 _amount) external;

    function updateReward(address _from, address _to) external;
}

contract One is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string public baseURI;
    bytes32 public baseExtension = ".json";
    string public notRevealedUri;
    uint256 public cost = 0.00 ether;
    uint256 public maxSupply = 10000;
    uint256 public maxMintAmount = 1;
    uint256 public nftPerAddressLimit = 1;
    uint256 public wlMaxPerTx = 1;
    uint256 public wlMaxPerWallet = 1;
    bool public paused = false;
    bool public revealed = false;
    bool public onlyWhitelisted = true;
    address[] public whitelistedAddresses;
    address juiceAdress;
    mapping(address => uint256) public addressMintedBalance;

    IJuice public Juice;

    constructor(string memory _initBaseURI, string memory _initNotRevealedUri)
        ERC721("TokenName", "TKN")
    {
        setBaseURI(_initBaseURI);
        setNotRevealedURI(_initNotRevealedUri);
    }

    // INTERNAL FUNCTIONS

    // @dev function returns the BaseURI
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    // PUBLIC FUNCTIONS

    // @dev function to mint an NFT
    // @param _mintAmount => Quantity to mint
    //
    function mint(uint256 _mintAmount) public payable {
        require(!paused, "the contract is paused");
        uint256 supply = totalSupply();
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        require(
            _mintAmount <= maxMintAmount,
            "max mint amount per session exceeded"
        );
        require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");

        uint256 ownerMintedCount = addressMintedBalance[msg.sender];
        require(msg.value >= cost * _mintAmount, "insufficient funds");
        require(
            ownerMintedCount + _mintAmount <= nftPerAddressLimit,
            "max NFT per address exceeded"
        );
        if (onlyWhitelisted == true) {
            require(isWhitelisted(msg.sender), "user is not whitelisted");
            require(
            _mintAmount <= wlMaxPerTx,
            "max mint amount per session exceeded"
         );
            require(
            ownerMintedCount + _mintAmount <= wlMaxPerWallet,
            "max NFT per address exceeded"
         );
        }

        for (uint256 i = 0; i < _mintAmount; i++) {
            addressMintedBalance[msg.sender]++;
            _safeMint(msg.sender, supply + i);
        }
    }

    // Fuction that checks if the _user is WhiteListed
    // @dev The function will check in the array of WhitelistedAddresses if the _user is WhiteListed.
    function isWhitelisted(address _user) public view returns (bool) {
        for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
            if (whitelistedAddresses[i] == _user) {
                return true;
            }
        }
        return false;
    }

    /*
  function isWhitelisted(address _user) public view returns (bool) {
    return whitelistedChecker[_user];
  }
  */

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
        // Eliminate a friend
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
    // If the revealed = false the TokenURI will be the metadata of a lovely Loda
    // If the revealed = true the TokenURI will lead you to your crazy Lemmy/s
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (revealed == false) {
            return notRevealedUri;
        }

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

    // Override the functions of Transfer and SafeTransfer
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        if (tokenId < maxSupply) {
            //Juice.updateReward(from, to);
        }
        ERC721.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public override {
        if (tokenId < maxSupply) {
            //Juice.updateReward(from, to);
        }
        ERC721.safeTransferFrom(from, to, tokenId, data);
    }

    // ONLY OWNER FUNCTIONS

    // Sets the contractc of $JUICE
    function setLemonJuiceMachine(address _juiceAddress) external onlyOwner {
        Juice = IJuice(_juiceAddress);
    }

    // Reveal function => Cambiarlo de false a true
    function reveal() public onlyOwner {
        revealed = true;
    }

    // Set the baseURI
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    // Set the base Extension, default => .json
    function setBaseExtension(bytes32 _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    // Set the not revealed uri => Yoda
    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    // Change the state of Pause => Cambiarlo para usar Pausable.sol de Openzeppelin
    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    // Set the only white listed state => Arranca en True
    function setOnlyWhitelisted(bool _state) public onlyOwner {
        onlyWhitelisted = _state;
    }

    // Deletes whitelist array and you can set a new one
    function whitelistUsers(address[] calldata _users) public onlyOwner {
        delete whitelistedAddresses;
        whitelistedAddresses = _users;
    }

    // Withdraw all the eth inside the smart contract to the msg.sender address
    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }
}
