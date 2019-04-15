pragma solidity ^0.5.0;

import "./ERC20.sol";
import "./ERC20Detailed.sol";

/**
 * @title RealEstateManagement
 * @dev
 */

contract RealEstateManagement is ERC20, ERC20Detailed {
    uint256 public constant INITIAL_SUPPLY = tSupply*(10**18);

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor () public ERC20Detailed(tName, tSymbol, 18) {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
}
