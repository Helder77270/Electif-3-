// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
 
import {Test, console} from "forge-std/Test.sol";
import {Marketplace} from "../src/Marketplace.sol";
 
contract MarketplaceTest is Test {
    Marketplace public marketplace;
    address admin;
    address user;
 
    function setUp() public {
        admin = address(0x123);
        user = address(0x456);
        vm.prank(admin);
            marketplace = new Marketplace(1000);
        vm.stopPrank();
    }
 
    // function testTokenNameAndSymbol() public {
    //     assertEq("MONEY", marketplace.name(), "Les noms de tokens sont differents");
    //     assertEq("$DOL", marketplace.symbol(), "Les symboles sont differents");
    // }
 
    // function testMintAndTotalSupply() public {
    //     assertEq(1000, marketplace.balanceOf(admin), "Le montant minte est incorrect pour l'admin");
    //     assertEq(1000, marketplace.totalSupply(), "Le total supply est incorrect");
 
    //     vm.prank(admin);
    //     marketplace.mint(user, 1000);
    //     assertEq(1000, marketplace.balanceOf(user), "Le montant minte est incorrect pour l'utilisateur");
    //     assertEq(2000, marketplace.totalSupply(), "Le total supply est incorrect");
    //     vm.stopPrank();
    // }
 
    function testCreateItem() public {

        // On passe en mode admin car la fonction createItem est protégé par le modifier onlyOwner
        vm.prank(admin);
        
        // Permets de setup le timestamp
        vm.warp(1);
        // On appelle la fonction createItem, étant le premier créer de la liste son id = 0
        marketplace.createItem("item1", 100);

         // Déstructurer les valeurs de l'item retourné par le mapping
        (string memory name, uint256 price, uint256 timestamp, address owner) = marketplace.getItemById(0);

        assertEq("item1", name, "Le nom de l'item est incorrect");
        assertEq(100, price, "Le prix de l'item est incorrect");
        assertEq(1, timestamp, "Le timestamp de l'item est incorrect");
        assertEq(address(0), owner, "Le timestamp de l'item est incorrect");

        vm.stopPrank();
    }

    function testFailCreateItemByUser() public {
         // On passe en mode admin car la fonction createItem est protégé par le modifier onlyOwner
        vm.prank(user);
        
        // Permets de setup le timestamp
        vm.warp(1);
        // On appelle la fonction createItem, étant le premier créer de la liste son id = 0
        marketplace.createItem("item1", 100);

        vm.stopPrank();
    }

    function testBuyItem() public {
    // Simuler que l'administrateur crée un item
    vm.prank(admin);
    vm.warp(1);
    marketplace.createItem("item1", 100);

    // Déstructurer l'item créé pour vérifier ses valeurs
    (string memory name, uint256 price, uint256 timestamp, address owner) = marketplace.getItemById(0);
    assertEq(owner, address(0), "L'item devrait ne pas avoir de proprietaire initial");

    // Simuler que l'administrateur effectue un mint pour le user
    vm.prank(admin); // Prank pour garantir que seul l'admin appelle mint
    marketplace.mint(user, 1000);

    // Simuler que l'utilisateur achète l'item
    vm.prank(user);
    marketplace.buyItem(0);

    // Vérifier que le propriétaire de l'item est maintenant l'utilisateur
    (string memory name1, uint256 price1, uint256 timestamp1, address owner1) = marketplace.getItemById(0);
    assertEq(user, owner1, "L'utilisateur devrait etre le proprietaire de l'item apres l'achat");

    // Vérifier que le solde du user a été mis à jour
    assertEq(marketplace.balanceOf(user), 900, "Le solde de l'utilisateur devrait etre 900 apres l'achat");
    }

}