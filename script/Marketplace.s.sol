// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Marketplace} from "../src/Marketplace.sol";

contract MarketplaceScript is Script {
    Marketplace public marketplace;
    uint256 initialSupply = 10000 * 10 ** 18;

    function setUp() public {}

    function run() public {
        // Récupérer les adresses depuis l'environnement
        address sender = vm.envAddress("SENDER_ADDRESS");
        address buyer = vm.envAddress("BUYER_ADDRESS");

        vm.startBroadcast(sender);

        // Déploiement du contrat Marketplace
        marketplace = new Marketplace(initialSupply);
        console.log("Contract address :", address(marketplace));
        console.log("Deployer address: ", sender);

        // Mint des tokens à l'admin
        marketplace.mint(sender, 10000 * 10**18);

        // Mint des tokens à l'acheteur (correction)
        marketplace.mint(buyer, 16 * 10**18); // L'acheteur doit avoir des tokens
        console.log("Minted tokens: ", marketplace.balanceOf(sender));
        console.log("Buyer tokens: ", marketplace.balanceOf(buyer));

        // Création des articles sur le Marketplace
        marketplace.createItem("Computer", 10 * 10 ** 18);
        marketplace.createItem("Keyboard", 6 * 10 ** 18);
        marketplace.createItem("Wifi Card", 8 * 10 ** 18);

        vm.stopBroadcast();

        vm.startBroadcast(buyer);

        // Vérification des fonds de l'acheteur avant achat
        console.log("Buyer balance before purchases: ", marketplace.balanceOf(buyer));
        
        
        // L'acheteur achète les items (envoie de l'adresse correcte)
        marketplace.buyItem(0);
        console.log("Item 0 bought by:", buyer);

        marketplace.buyItem(1);
        console.log("Item 1 bought by:", buyer);

        marketplace.buyItem(2);
        console.log("Item 2 bought by:", buyer);

        // Vérification du solde après achats
        console.log("Buyer balance after purchases: ", marketplace.balanceOf(buyer));

        vm.stopBroadcast();
    }
}
