pragma solidity ^0.5.7;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Roles.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol";

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
        require(isWhitelistedDeveloper(msg.sender));
        _;
    }

    function isWhitelistedDeveloper(address account) public view returns (bool) {
        return _whitelistedDevelopers.has(account);
    }

    function addWhitelistedDeveloper(address account) public onlyWhitelistAdmin {
        _addWhitelistedDeveloper(account);
    }

    function removeWhitelistedDeveloper(address account) public onlyWhitelistAdmin {
        _removeWhitelistedDeveloper(account);
    }

    function renounceWhitelistedDeveloper() public {
        _removeWhitelistedDeveloper(msg.sender);
    }

    function _addWhitelistedDeveloper(address account) internal {
        _whitelistedDevelopers.add(account);
        emit WhitelistedDevelopersAdded(account);
    }

    function _removeWhitelistedDeveloper(address account) internal {
        _whitelistedDevelopers.remove(account);
        emit WhitelistedDevelopersRemoved(account);
    }
}
