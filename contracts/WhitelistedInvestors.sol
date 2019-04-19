pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/access/Roles.sol";
import "openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol";

/**
 * @title WhitelistedInvestors
 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Whitelisteds themselves.
 */
contract WhitelistedInvestors is WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistedInvestorsAdded(address indexed account);
    event WhitelistedInvestorsRemoved(address indexed account);

    Roles.Role private _whitelistedInvestors;

    modifier onlyWhitelistedInvestors() {
        require(isWhitelistedInvestors(msg.sender));
        _;
    }

    function isWhitelistedInvestors(address account) public view returns (bool) {
        return _whitelistedInvestors.has(account);
    }

    function addWhitelistedInvestors(address account) public onlyWhitelistAdmin {
        _addWhitelistedInvestors(account);
    }

    function removeWhitelistedInvestors(address account) public onlyWhitelistAdmin {
        _removeWhitelistedInvestors(account);
    }

    function renounceWhitelistedInvestors() public {
        _removeWhitelistedInvestors(msg.sender);
    }

    function _addWhitelistedInvestors(address account) internal {
        _whitelistedInvestors.add(account);
        emit WhitelistedInvestorsAdded(account);
    }

    function _removeWhitelistedInvestors(address account) internal {
        _whitelistedInvestors.remove(account);
        emit WhitelistedInvestorsRemoved(account);
    }
}
