pragma solidity ^0.5.2;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Roles.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol";

/**
 * @title WhitelistedInvestors
 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Whitelisteds themselves.
 */
contract WhitelistedInvestors is WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistedInvestorAdded(address indexed account);
    event WhitelistedInvestorRemoved(address indexed account);

    Roles.Role private _whitelistedInvestors;

    modifier onlyWhitelistedInvestors() {
        require(isWhitelistedInvestor(msg.sender));
        _;
    }

    function isWhitelistedInvestor(address account) public view returns (bool) {
        return _whitelistedInvestors.has(account);
    }

    function addWhitelistedInvestor(address account) public onlyWhitelistAdmin {
        _addWhitelistedInvestor(account);
    }

    function removeWhitelistedInvestor(address account) public onlyWhitelistAdmin {
        _removeWhitelistedInvestor(account);
    }

    function renounceWhitelistedInvestor() public {
        _removeWhitelistedInvestor(msg.sender);
    }

    function _addWhitelistedInvestor(address account) internal {
        _whitelistedInvestors.add(account);
        emit WhitelistedInvestorAdded(account);
    }

    function _removeWhitelistedInvestor(address account) internal {
        _whitelistedInvestors.remove(account);
        emit WhitelistedInvestorRemoved(account);
    }
}
