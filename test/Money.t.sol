// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Money} from "../src/Money.sol";

contract MoneyTest is Test {
    Money public money;
    address admin;
    address user;

    function setUp() public {
        admin = address(0x123);
        user = address(0x456);

        // ON UTILISE DE FORCE L'ADRESSE DE L'ADMINISTRATEUR
        vm.startPrank(admin);
     
            money = new Money(1000); // On déploie le contrat

        vm.stopPrank();
    }

    function testTokenNameAndSymbol() public {
        assertEq("MONEY", money.name(), "Les noms de tokens sont differents");
        assertEq("$DOL", money.symbol(), "Les symboles sont differents");
    }

    function testMintAndTotalSupply() public {
        assertEq(1000, money.balanceOf(admin), "le montant mint est different");
        assertEq(1000, money.totalSupply(), "La total supply est differente du montant cree");

        vm.startPrank(admin);

            money.mint(user, 1000);

            assertEq(1000, money.balanceOf(user), "Le montant mint est different pour le user");
            assertEq(2000, money.totalSupply(), "La total supply est differente du total cree");

        vm.stopPrank();
    }
     
//    function testMintEvent() public {
//     // Simuler que l'appel est fait par l'admin
//     vm.prank(admin);

//     // Configurer la vérification de l'émission de l'événement
//     vm.expectEmit(true, true, true, false); // Vérifie les champs `indexed`
//     emit Transfer(address(0), user, 3000); // Événement attendu

//     // Appeler la fonction qui émet l'événement
//     money.mint(user, 3000);

//     // Arrêter la simulation de l'utilisateur
//     vm.stopPrank();
// }

}