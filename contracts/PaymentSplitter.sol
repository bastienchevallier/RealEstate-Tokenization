pragma solidity ^0.5.3;

import "./SafeMath.sol";
import "./WhitelistAdminRole.sol";
import "./ProjectCrowdsale.sol";
import './ProjectToken.sol';
import './IERC20.sol';

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

    ProjectCrowdsale private _crowdsalecontract;
    IERC20 private _token;

    /**
     * @dev Constructor
     */
    constructor (address contractAddress) public payable {
        _crowdsalecontract = ProjectCrowdsale(contractAddress);
        _token = IERC20(_crowdsalecontract.token());
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
