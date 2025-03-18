// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Money} from "./Money.sol";

contract Marketplace is Money {
    struct Item {
        string name;
        uint256 price;
        address owner;
        bool status;
        uint256 timestamp;
    }

    mapping(uint256 id => Item) private items;
    uint256 itemCounter = 0;

    modifier isValidId(uint256 id) {
        require(id < itemCounter, ItemNotFound());
        _;
    }

    event ItemCreated(
        string name_,
        uint256 price_,
        address owner,
        uint256 timestamp
    );

    error ItemNotAvailable();
    error InsufficientBalance();
    error CannotBuyOwnItem();
    error ItemNotFound();
    error ItemAlreadyExists();
    error ItemNotOwned();

    constructor(
        string memory name,
        string memory symbol
    ) Money(name, symbol) {}

    function createItem(
        string memory name_,
        uint256 price_
    ) external onlyOwner {
        items[itemCounter] = Item(
            name_, price_, address(this), false, block.timestamp
        );
        itemCounter++;
        emit ItemCreated(name_, price_, address(this), block.timestamp);
    }

    function getContractAddress() external view returns (address) {
        return address(this);
    }

    function getItemById(
        uint256 id
    ) external view isValidId(id) returns (Item memory item) {
        return items[id];
    }

    function getAllItems() external view returns (Item[] memory) {
        Item[] memory allItems = new Item[](100);
        for (uint256 i = 0; i < 100; i++) {
            allItems[i] = items[i];
        }
        return allItems;
    }

    function buyItem(uint256 id) external {
        require(items[id].status, ItemNotAvailable());
        require(msg.sender != items[id].owner, CannotBuyOwnItem());
        require(
            balanceOf(msg.sender) >= items[id].price,
            InsufficientBalance()
        );

        items[id].owner = msg.sender;
        items[id].status = false;
        transfer(items[id].owner, items[id].price);
    }

    function setItemStatus(
        uint256 id,
        bool status
    ) public onlyOwner isValidId(id) {
        require(id < itemCounter, ItemNotFound());
        items[id].status = status;
    }

    function getItemStatus(
        uint256 id
    ) public view isValidId(id) returns (bool) {
        return items[id].status;
    }
}