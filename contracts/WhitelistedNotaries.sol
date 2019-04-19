pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/access/Roles.sol";
import "openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol";

/**
 * @title WhitelistedNotaries
 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Whitelisteds themselves.
 */
contract WhitelistedNotaries is WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistedNotariesAdded(address indexed account);
    event WhitelistedNotariesRemoved(address indexed account);

    Roles.Role private _whitelistedNotaries;

    modifier onlyWhitelistedNotaries() {
        require(isWhitelistedNotaries(msg.sender));
        _;
    }

    function isWhitelistedNotaries(address account) public view returns (bool) {
        return _whitelistedNotaries.has(account);
    }

    function addWhitelistedNotaries(address account) public onlyWhitelistAdmin {
        _addWhitelistedNotaries(account);
    }

    function removeWhitelistedNotaries(address account) public onlyWhitelistAdmin {
        _removeWhitelistedNotaries(account);
    }

    function renounceWhitelistedNotaries() public {
        _removeWhitelistedNotaries(msg.sender);
    }

    function _addWhitelistedNotaries(address account) internal {
        _whitelistedNotaries.add(account);
        emit WhitelistedNotariesAdded(account);
    }

    function _removeWhitelistedNotaries(address account) internal {
        _whitelistedNotaries.remove(account);
        emit WhitelistedNotariesRemoved(account);
    }
}
