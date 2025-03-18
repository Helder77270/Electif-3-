// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Marketplace} from "../src/Marketplace.sol";

contract MarketplaceTest is Test {
    Marketplace public marketplace;
    address admin;
    address user;
    error OwnableUnauthorizedAccount(address caller);
    function setUp() public {
        admin = address(0x123);
        user = address(0x456);

        // ON UTILISE DE FORCE L'ADRESSE DE L'ADMINISTRATE8UR
        vm.startPrank(admin);
     
            marketplace = new Marketplace("$MONEY$", "$$$"); // On déploie le contrat
            
        vm.stopPrank();
    }

    /// 
    function testMintByNonOwner() public {
        vm.expectRevert(abi.encodeWithSelector(OwnableUnauthorizedAccount.selector, user));
        vm.startPrank(user);

            marketplace.mint(user, 1000);
        vm.stopPrank();

    }

function testCreateItemEvent() public {
    // Définir les valeurs attendues
    string memory expectedName = "TestItem";
    uint256 expectedPrice = 1000;
    // Dans createItem, l'owner est défini comme address(this) (l'adresse du contrat)
    address expectedOwner = address(marketplace);
    // Pour le timestamp, afin d’éviter les problèmes liés à block.timestamp,
    // vous pouvez fixer le temps avec vm.warp() avant l'appel ou vérifier partiellement.
    uint256 expectedTimestamp = block.timestamp; 

    // Indiquer que l'on souhaite vérifier tous les champs de l'événement.
    vm.expectEmit(true, true, true, true);
    emit Marketplace.ItemCreated(expectedName, expectedPrice, expectedOwner, expectedTimestamp);

    // Exécuter la fonction qui doit émettre l’événement
    vm.startPrank(admin);
         marketplace.createItem(expectedName, expectedPrice);
    vm.stopPrank();
}
}