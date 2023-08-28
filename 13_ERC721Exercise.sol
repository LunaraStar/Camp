// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    error HaikuNotUnique();
    error NotHaikuOwner();
    error NoHaikusShared();

    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }
    Haiku[] public haikus;
    mapping (address => uint[]) public sharedHaikus;
    uint public counter = 1;
    mapping (string => bool) private existedLines;

    constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function mintHaiku(
        string calldata _line1,
        string calldata _line2,
        string calldata _line3) external {
            if (existedLines[_line1] || existedLines[_line2] || existedLines[_line3]) {
                revert HaikuNotUnique();
            }
            existedLines[_line1] = true;
            existedLines[_line2] = true;
            existedLines[_line3] = true;

            Haiku memory newHaiku = Haiku(msg.sender, _line1, _line2, _line3);
            haikus.push(newHaiku);

            _safeMint(msg.sender, counter);
            counter++;
        }

        function shareHaiku(uint _tokenId, address _to) public {
            if (ownerOf(_tokenId) == msg.sender) {
                sharedHaikus[_to].push(_tokenId);
            } else {
                revert NotHaikuOwner();
            }
        }

        function getMySharedHaikus() public view returns (Haiku[] memory) {
            uint[] memory userSharedHaikusIds = sharedHaikus[msg.sender];
            uint nShared = userSharedHaikusIds.length;
            if (nShared == 0) {
                revert NoHaikusShared();
            }
            Haiku[] memory userSharedHaikus = new Haiku[](nShared);

            for (uint i = 0; i < nShared; i++) {
                userSharedHaikus[i] = haikus[userSharedHaikusIds[i] - 1];
            }

            return userSharedHaikus;
        }
}
