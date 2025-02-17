pragma solidity ^0.8.20;
 
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol"; // ERC20 normes tokens --> Cryptomonnaies
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
 
contract Money is ERC20, Ownable {

    // Se lance au déploiement
    constructor(uint256 initialSupply) ERC20("MONEY", "$DOL") Ownable(msg.sender){
       _mint(msg.sender, initialSupply); // mint génère des tokens pour une adresse donnée
   }
 
    // Créé une fonction mint personnalisé
    // function <nom> (params...) <visibilité> <modifier>
    // Modifier = vérfication pré et post transaction
   function mint(address account, uint256 value) public onlyOwner {
       _mint(account, value);
   }
 
}
 