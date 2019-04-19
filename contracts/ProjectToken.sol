pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';

/**
 * @title ProjectToken
 * @dev This contract defines the token associated to the asset and the rules of
 * payment splitting.
 */

contract ProjectToken is ERC20, ERC20Detailed {

  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
  constructor (
      string memory name,
      string memory symbol,
      uint8 DECIMALS,
      uint256 INITIAL_SUPPLY
    )
      public
      ERC20Detailed(name, symbol, DECIMALS)
    {
      _mint(msg.sender, INITIAL_SUPPLY*(10**uint256(DECIMALS)));
    }
}
