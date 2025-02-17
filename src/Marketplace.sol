pragma solidity ^0.8.28;
 
import "./Money.sol";
 
/**
 * @title Marketplace
 * @dev A contract for creating and buying items using a custom token
 * @notice Inherits from Money contract and manages item sales
 */
contract Marketplace is Money {
   /// @dev Counter to track the number of items created
   uint256 storeCounter;
 
   /**
    * @dev Struct to represent an item in the marketplace
    * @param name Name of the item
    * @param price Price of the item
    * @param timestamp Timestamp of item creation
    * @param owner Address of the item owner
    */
   struct Item {
           string name;
           uint256 price;
           uint256 timestamp;
           address owner;
   }
 
   /// @dev Mapping to store items by their unique ID
   mapping (uint256 id => Item) public Items; // clé => valeur
 
   /// @dev Custom error for incorrect payment amount
   /// @param sentAmount Amount of payment sent
   /// @param awaitedAmount Expected payment amount
   error IncorrectPaymentAmount(uint256 sentAmount, uint256 awaitedAmount);
 
   /**
    * @dev Constructor initializes the marketplace with initial token supply
    * @param initSupply Initial token supply
    */
   constructor(uint256 initSupply) Money(initSupply){
       
   }
 
   /**
    * @dev Creates a new item in the marketplace
    * @notice Only contract owner can create items
    * @param _name Name of the item
    * @param _price Price of the item
    */
   function createItem(string calldata _name, uint256 _price) public onlyOwner{
       Item memory item = Item(_name, _price, block.timestamp, address(0));
       Items[storeCounter] = item;
       storeCounter++;
   }

   /// @dev Custom error for time-related issues
   /// @param minimalTimestamp Minimum allowed timestamp
   error TimeIssue(uint256 minimalTimestamp);

   /**
    * @dev Allows purchasing an item from the marketplace
    * @param _id Unique identifier of the item to buy
    * @notice Transfers tokens and updates item ownership
    */
   function buyItem(uint256 _id) public {

    (string memory name, uint256 price, uint256 timestamp, address owner) = getItem(_id);
    require(block.timestamp > timestamp, TimeIssue(timestamp));

    transfer(owner, price);
    Items[_id].owner = msg.sender;
   }

   /**
    * @dev Retrieves item details
    * @param _id Unique identifier of the item
    * @return Item name, price, timestamp, and owner
    */
   function getItemById(uint _id) public view returns(string memory, uint, uint, address){
        return (Items[_id].name, Items[_id].price, Items[_id].timestamp, Items[_id].owner);
   }

   /**
    * @dev Retrieves item details
    * @param _id Unique identifier of the item
    * @return Item name, price, timestamp, and owner
    */
   function getItemById2(uint _id) public view returns(Item memory){
        return Items[_id];
   }
}