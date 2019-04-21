pragma solidity ^0.5.2;
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/Math.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

import './ProjectToken.sol';


/**
 * @title PaymentSplitter
 * @dev This contract is used when payments are received
 * and split proportionately to some number of tokens investors own.
 */
contract PaymentSplitter {
    using SafeMath for uint256;

    event PaymentReleased(address to, uint256 amount);
    event PaymentReceived(address from, uint256 amount);

    uint256 private _totalReleased;
    mapping(address => uint256) private _released;

    IERC20 private _token;

    /**
     * @dev Constructor
     */
    constructor (address token) public payable {
        _token = IERC20(token);
    }

    /**
     * @dev payable fallback
     */
    function () external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    /**
     * @return the total supply of the contract.
     */
    function totalTokenSupply() public view returns (uint256) {
        return _token.totalSupply();
    }

    /**
     * @return the total amount already released.
     */
    function totalReleased() public view returns (uint256) {
        return _totalReleased;
    }

    /**
     * @return the number of tokens of an account.
     */
    function tokensOf(address account) public view returns (uint256) {
        return _token.balanceOf(account);
    }

    /**
     * @return the amount already released to an account.
     */
    function released(address account) public view returns (uint256) {
        return _released[account];
    }

    function balance() public view returns(uint256){
        return address(this).balance;
    }

    /**
     * @dev Release one of the payee's proportional payment.
     * @param account Whose payments will be released.
     */
    function release(address payable account) public {
        require(tokensOf(account) > 0);

        uint256 totalReceived = address(this).balance.add(_totalReleased);
        uint256 payment = totalReceived.mul(tokensOf(account)).div(totalTokenSupply()).sub(_released[account]);

        require(payment != 0);

        _released[account] = _released[account].add(payment);
        _totalReleased = _totalReleased.add(payment);

        account.transfer(payment);
        emit PaymentReleased(account, payment);
    }
}
