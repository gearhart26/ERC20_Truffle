// TOPIC: Openzeppelin  -->  VIDEO: "Custom Extensions & Assignment"  

// ERC20 Token assignment for Ethereum Smart Contract Programming 201.
    // Need an ERC 20 token with:
    //  -Minting
    //  -Token burning
    //  -Pause/Unpause ability
    //  -Built in token cap
    //  -Access control
    //  -New acess role with ability to change token cap after contract launch

pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "../node_modules/@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "../node_modules/@openzeppelin/contracts/utils/Context.sol";

    //  ERC20 Token with:
    //  - ability for holders to burn (destroy) their tokens
    //  - a minter role that allows for token minting (creation)
    //  - a pauser role that stops all token transfers
    // This contract uses {AccessControl} to lock permissioned functions using the different roles
    // The account that deploys the contract will be granted the minter and pauser roles, as well as 
    // the default admin role, which will let it grant both minter and pauser roles to other accounts.
contract MyERC20_MintPauseCap is Context, AccessControlEnumerable, ERC20Burnable, ERC20Pausable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
        // Adding a role for someone to change the token cap. This is a bad idea to have, but it is part of the assignment.
    bytes32 public constant CAPSETTER_ROLE = keccak256("CAPSETTER_ROLE");

        //Total token cap
    uint256 private _cap;

        // Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the account that deploys the contract.
        // Adding ERC20Capped.sol variables and requirements to constructor
    constructor(string memory name, string memory symbol, uint256 cap_) ERC20(name, symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
            // Setting up new CAPSETTER role
        _setupRole(CAPSETTER_ROLE, _msgSender());
            // ERC20Capped constructor 
        require(cap_ > 0, "Cap is 0");
        _cap = cap_;
    }

        // Creates `amount` new tokens for `to`. The caller must have the `MINTER_ROLE`.
    function mint(address to, uint256 amount) public virtual {
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to mint");
        _mint(to, amount);
    }

        //Pauses all token transfers. The caller must have the `PAUSER_ROLE`.
    function pause() public virtual {
        require(hasRole(PAUSER_ROLE, _msgSender()), "Must have pauser role to pause");
        _pause();
    }

        //Unpauses all token transfers. The caller must have the `PAUSER_ROLE`.
    function unpause() public virtual {
        require(hasRole(PAUSER_ROLE, _msgSender()), "Must have pauser role to unpause");
        _unpause();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }

// Adding Capped Functionality From ERC20Capped.sol
        //Returns cap on total supply
    function cap() public view virtual returns (uint256) {
        return _cap;
    }

        // Overrideing _mint function from inherited ERC20 contract
    function _mint(address account, uint256 amount) internal virtual override {
        require(ERC20.totalSupply() + amount <= cap(), "Cap exceeded");
        super._mint(account, amount);
    }

        // Changes token cap. The caller must have the `CAPSETTER_ROLE`.
    function changeCap(uint256 newcap_) public virtual {
        require(hasRole(CAPSETTER_ROLE, _msgSender()), "Must have capsetter role to change token cap");
        require(ERC20.totalSupply() <= newcap_, "Cap exceeded");
        require(newcap_ > 0, "Cap is 0");
        _cap = newcap_;
    }

}
// SPDX-License-Identifier: MIT