pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol";


/**
 * @title WhitelistedInvestors
 * @dev This contract inherits WhitelistedRole contract and defines how whitelisted
 * investors are allowed to participate and invest in projects
 */

contract WhitelistedInvestors is WhitelistedRole {
  //Buy tokens

  //Exchange/Sell tokens

  //Receive a portion of the rent
}

 /**
  * @title WhitelistedLandlords
  * @dev This contract inherits WhitelistedRole contract and defines how whitelisted
  * landlords are allowed to create and deploy smart contracts to tokenize their assets.
  */

contract WhitelistedLandlords is WhitelistedRole {
  //Token creation

  //Token offering

  //Withdraw function
  //function withdraw() onlyWhitelisted(){
}

  //Receive a portion of the rent
}

/**
 * @title ParentContract
 * @dev This contract defines the main methods to tokenize an asset and create/exchange a performance swap token.
 */

contract ParentContract {

}
