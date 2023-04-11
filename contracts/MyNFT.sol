//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor()  ERC721("MyNFT", "NFT") {}

    function mintNFT(address recipient, string memory tokenURI)
        public onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    struct Retailer{
        string name;
        bool authorized;
    }

    mapping(address => Transaction[]) transactions;

    struct Product{
        string name;
        int amount;
        int warrantyPeriod; //seconds
    }

    struct Transaction{
        string orderId;
        string productId;
        Product product;
    }

    address public owner1;
    string public storeName;
    Transaction[] totalTransactions;

    mapping(address => Retailer) retailers;

    modifier ownerOnly() {
        require(msg.sender == owner1);
        _;
    }

    modifier retailerOnly() {
        require(retailers[msg.sender].authorized == true);
        _;
    }

    function startStore(string memory _storeName) public {
        owner1 = msg.sender;
        storeName = _storeName;
    }

    function authorizeRetailer(address _retailerAddress, string memory _retailerName)ownerOnly public {
        retailers[_retailerAddress] = Retailer(_retailerName, true);
    }

    function addTransaction(address _consumerAddress, Transaction memory transaction)retailerOnly public {
        transactions[_consumerAddress].push(transaction);
    }
}