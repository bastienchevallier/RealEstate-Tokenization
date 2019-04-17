pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./SafeMath.sol";


/
/**
 * @title ProjectContract
 * @dev This contract defines the token associated to the asset and the rules of
 * payment splitting.
 */

contract ProjectContract is ERC20 {
  using SafeMath for uint256;

  event PaymentReleased(address to, uint256 amount);
  event PaymentReceived(address from, uint256 amount);

  uint256 private _totalReleased;

  mapping(address => uint256) private _released;
  address payable[] private _investors;

  /** Token creation */

  /** Rent splitting */
  /**
   * @dev The Ether received will be logged with `PaymentReceived` events. Note that these events are not fully
   * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
   * reliability of the events, and not the actual splitting of Ether.
   *
   * To learn more about this see the Solidity documentation for [fallback functions].
   *
   * [fallback functions]: https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function
   */
  function () external payable {
      emit PaymentReceived(msg.sender, msg.value);
  }

  function contractBalance() public view returns (uint256) {
      return address(this).balance;
  }

  /**
   * @dev Getter for the total amount of Ether already released.
   */
  function totalReleased() public view returns (uint256) {
      return _totalReleased;
  }

  /**
   * @dev Getter for the amount of Ether already released to a payee.
   */
  function released(address account) public view returns (uint256) {
      // TODO: Can everybody checks what other released ?
      //require(account == msg.sender);
      return _released[account];
  }

  /**
   * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
   * total shares and their previous withdrawals.
   */
  function release(address payable account) public {
      require(balanceOf(account) > 0);

      uint256 totalReceived = address(this).balance.add(_totalReleased);
      uint256 payment = totalReceived.mul(balanceOf(account)).div(totalSupply()).sub(_released[account]);

      require(payment != 0);

      _released[account] = _released[account].add(payment);
      _totalReleased = _totalReleased.add(payment);

      account.transfer(payment);
      emit PaymentReleased(account, payment);
  }

}
