pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/access/Roles.sol";
import "openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol";

/**
 * @title WhitelistedDevelopers
 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Whitelisteds themselves.
 */
contract WhitelistedDevelopers is WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistedDevelopersAdded(address indexed account);
    event WhitelistedDevelopersRemoved(address indexed account);

    Roles.Role private _whitelistedDevelopers;

    modifier onlyWhitelistedDevelopers() {
        require(isWhitelistedDevelopers(msg.sender));
        _;
    }

    function isWhitelistedDevelopers(address account) public view returns (bool) {
        return _whitelistedDevelopers.has(account);
    }

    function addWhitelistedDevelopers(address account) public onlyWhitelistAdmin {
        _addWhitelistedDevelopers(account);
    }

    function removeWhitelistedDevelopers(address account) public onlyWhitelistAdmin {
        _removeWhitelistedDevelopers(account);
    }

    function renounceWhitelistedDevelopers() public {
        _removeWhitelistedDevelopers(msg.sender);
    }

    function _addWhitelistedDevelopers(address account) internal {
        _whitelistedDevelopers.add(account);
        emit WhitelistedDevelopersAdded(account);
    }

    function _removeWhitelistedDevelopers(address account) internal {
        _whitelistedDevelopers.remove(account);
        emit WhitelistedDevelopersRemoved(account);
    }
}
