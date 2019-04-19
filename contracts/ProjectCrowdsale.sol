pragma solidity ^0.5.2;

import './ProjectToken.sol';
import 'openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';

contract ProjectCrowdsale is CappedCrowdsale {
  using SafeMath for uint256;

  ERC20Detailed private _token = new ProjectToken('House', 'HOU', 18, 10000);

  mapping(address => uint256) private _released;
  address payable[] private _investors;

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
    // require(isWhitelisted(msg.sender))
  }


  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
    // TODO Check if beneficiary is Whitelisted
    // require(isWhitelisted(_beneficiary));
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }

  function balanceOf(address owner) public view returns (uint256){
      return _token.balanceOf(owner);
  }
}
