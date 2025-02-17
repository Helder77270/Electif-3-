// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Money} from "../src/Money.sol";

contract MoneyScript is Script {
    Money public money;
    uint256 initialSupply = 10000 * 10 ** 18;
    function setUp() public {}

    function run() public {
        address sender = vm.envAddress("SENDER_ADDRESS");
        
        vm.startBroadcast(sender);

        money = new Money(initialSupply); // Mint 10 000 tokens à l'admin
        console.log("Contract address :", address(money));
        console.log("Deployer address: ", sender);

        money.mint(sender, 10000 * 10**18); // Mint 10 000 tokens à l'admin
        console.log("Minted tokens: ", money.balanceOf(sender)); // Affiche 20 000 * 10 ** 18

        vm.stopBroadcast();
    }
}
