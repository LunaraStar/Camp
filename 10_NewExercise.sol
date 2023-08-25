// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressBook is Ownable{
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }
    uint _currId = 0;
    mapping (uint => Contact) private contacts;
    uint[] private contactIds;

    error ContactNotFound(uint _id);

    constructor(address _owner) Ownable() {}

    function addContact(
        string calldata _firstName,
        string calldata _lastName,
        uint[] calldata _phoneNumbers) external onlyOwner  {
        contacts[_currId] = Contact(_currId, _firstName, _lastName, _phoneNumbers);
        contactIds.push(_currId);
        _currId++;
    }

    function deleteContact(uint _id) external onlyOwner {
        if (bytes(contacts[_id].firstName).length == 0) {
            revert ContactNotFound(_id);
        }

        delete contacts[_id];

        for (uint i = 0; i < contactIds.length; i++) {
            if (contactIds[i] == _id) {
                contactIds[i] = contactIds[contactIds.length - 1];
                contactIds.pop();
            }
        }
    }

    function getContact(uint _id) external view returns (Contact memory) {
        if (bytes(contacts[_id].firstName).length == 0) {
            revert ContactNotFound(_id);
        }

        return contacts[_id];
    }

    function getAllContacts() external view returns (Contact[] memory) {
        Contact[] memory allContacts = new Contact[](contactIds.length);
        
        for (uint i; i < contactIds.length; i++) {
            allContacts[i] = contacts[contactIds[i]];
        }
        return allContacts;
    }
}

contract AddressBookFactory {
    function deploy() public returns (address){
        return address(new AddressBook(msg.sender));
    }
}
