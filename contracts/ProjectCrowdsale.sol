pragma solidity ^0.5.2;

import './ProjectToken.sol';
import './WhitelistedDevelopers';
import './WhitelistedInvestors';
import 'openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';

contract ProjectCrowdsale is CappedCrowdsale, WhitelistedDevelopers, WhitelistedInvestors {
  using SafeMath for uint256;

  constructor (
      uint256 _rate,
      address payable _wallet,
      address _token,
      uint256 _cap
    )
      public
      Crowdsale(_rate, _wallet, IERC20(_token))
      CappedCrowdsale(_cap)
      //onlyWhitelistedDevelopers
  {
  }

  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
    require(isWhitelistedInvestors(_beneficiary));
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }

  function balanceOf(address owner) public view returns (uint256){
      return token().balanceOf(owner);
  }
}
