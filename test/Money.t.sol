// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Money} from "../src/Money.sol";

contract MoneyTest is Test {
    Money public money;
    address admin;
    address user;

    function setUp() public {
        admin = address(0x123);
        user = address(0x456);

        // ON UTILISE DE FORCE L'ADRESSE DE L'ADMINISTRATE8UR
        vm.startPrank(admin);
     
            money = new Money("$MONEY$", "$$$"); // On déploie le contrat
            
        vm.stopPrank();
    }

    // FONCTIONS DE TESTS ICI
    function testTokenAndSymbolName() public view {
        assertEq("$MONEY$", money.name(), "LE NOM EST INEGAL");
        assertEq("$$$", money.symbol(), "LE SYMBOL EST INEGAL");
    }

    /// Faire un mint en simulant l'owner qui se mint 10 000 tokens, vous devez vérifier, sa balance et la totalSupply
    function testMintByAdmin() public {
        vm.startPrank(admin);
            money.mint(admin, 10000);
            money.mint(user, 10000);
        vm.stopPrank();

        assertEq(money.balanceOf(admin), 10000);
        assertEq(money.balanceOf(user), 10000);
        assertEq(money.totalSupply(), 20000);
    }
}
