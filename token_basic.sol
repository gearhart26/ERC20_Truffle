pragma solidity 0.8.0;

    // ".." means go back out of this folder and up one level then follow the file path to import the one we want
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {

        //filling the constructor from our inherited ERC20 contract
        //minting ourselves some tokens for testing
    constructor() ERC20("MyToken", "MTKN") {
        _mint(msg.sender, 1000);
    }

}