pragma solidity ^0.5.7;

import './ProjectToken.sol';
import './WhitelistedDevelopers.sol';
import './WhitelistedInvestors.sol';
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract ProjectCrowdsale is CappedCrowdsale, WhitelistedInvestors, WhitelistedDevelopers {
  using SafeMath for uint256;

  IERC20 private _token = new ProjectToken('L2Launch', 'L2L', 18, 10);

  constructor (
      uint256 _rate,
      address payable _wallet,
      uint256 _cap
    )
      public
      Crowdsale(_rate, _wallet, _token)
      CappedCrowdsale(_cap)
  {
    // TODO Check if msg.sender is a whitelisted project dev
    //require(isWhitelistedDevelopers(msg.sender))
  }


  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
    // TODO Check if beneficiary is Whitelisted
    require(isWhitelistedInvestor(_beneficiary));
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }

}
