pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/access/Roles.sol";
import "openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol";

/**
 * @title WhitelistedTenants
 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Whitelisteds themselves.
 */
contract WhitelistedTenants is WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistedTenantsAdded(address indexed account);
    event WhitelistedTenantsRemoved(address indexed account);

    Roles.Role private _whitelistedTenants;

    modifier onlyWhitelistedTenants() {
        require(isWhitelistedTenants(msg.sender));
        _;
    }

    function isWhitelistedTenants(address account) public view returns (bool) {
        return _whitelistedTenants.has(account);
    }

    function addWhitelistedTenants(address account) public onlyWhitelistAdmin {
        _addWhitelistedTenants(account);
    }

    function removeWhitelistedTenants(address account) public onlyWhitelistAdmin {
        _removeWhitelistedTenants(account);
    }

    function renounceWhitelistedTenants() public {
        _removeWhitelistedTenants(msg.sender);
    }

    function _addWhitelistedTenants(address account) internal {
        _whitelistedTenants.add(account);
        emit WhitelistedTenantsAdded(account);
    }

    function _removeWhitelistedTenants(address account) internal {
        _whitelistedTenants.remove(account);
        emit WhitelistedTenantsRemoved(account);
    }
}
