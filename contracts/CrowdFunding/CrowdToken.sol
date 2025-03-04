// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CrowdToken is ERC20, Ownable {
    address public minter;

    constructor() ERC20("CrowdToken", "CTK") Ownable(msg.sender) {
        // Initialization if needed
    }

    function setMinter(address _minter) external onlyOwner {
        minter = _minter;
    }

    // Mint tokens; only the authorized minter can call.
    function mint(address to, uint256 amount) external {
        require(msg.sender == minter, "Not authorized");
        _mint(to, amount);
    }
}