pragma solidity 0.8.0;

    // ".." means go back out of this folder and up one level then follow the file path to import the one we want
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "../node_modules/@openzeppelin/contracts/access/ownable.sol";

contract MyToken_OwnableCapped is ERC20Capped, Ownable {

        //filling the constructor from our inherited ERC20 contract and setting minting cap 
        //minting ourselves some tokens for testing
    constructor() ERC20("MyToken", "MTKN") ERC20Capped(100000) {
        _mint(msg.sender, 1000);
    }

}