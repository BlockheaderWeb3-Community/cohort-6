// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CrowdNFT {
    string public name = "UscNFT";
    string public symbol = "UNFT";

    mapping(uint256 => address) public ownerOf;
    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    uint256 public nextTokenId;

    function mint(address _to) public {
        uint256 tokenId = nextTokenId++;
        ownerOf[tokenId] = _to;
        balanceOf[_to]++;
        emit Transfer(address(0), _to, tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public {
        require(ownerOf[_tokenId] == msg.sender, "Not owner");
        ownerOf[_tokenId] = _to;
        balanceOf[msg.sender]--;
        balanceOf[_to]++;
        emit Transfer(msg.sender, _to, _tokenId);
    }
}