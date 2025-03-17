// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RewardNft is ERC721 {
    // using Counters for Counters.Counter;
    using Strings for uint256;

    uint256 public counter;

    address public owner;

    // Counters.Counter private _nftIds;

    uint256 public constant MAX_SUPPLY = 10;

    uint256 public totalMinted;

    string public uri;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory _uri
    ) ERC721(name_, symbol_) {
        uri = _uri;
        owner = msg.sender;
    }

    // function mintNFT(address minter) external {
    //     uint256 newTokenId = _nftIds.current();
    //     require(newTokenId <= MAX_SUPPLY, "limit exceeded");
    //     _safeMint(minter, newTokenId);
    //     _nftIds.increment();
    //     totalMinted += 1;
    // }

    function mintNFT(address to) public returns (uint256) {
        uint256 currentCount = counter;
        if (to == address(0)) {
            revert ERC721InvalidReceiver(address(0));
        }
        address previousOwner = _update(to, currentCount, address(0));
        counter++;
        if (previousOwner != address(0)) {
            revert ERC721InvalidSender(address(0));
        }

        return counter;
    }

    function getTotalMinted() public view returns (uint256) {
        return totalMinted;
    }

    function _baseURI() internal view override returns (string memory) {
        return uri;
    }

    function setBaseUri(string memory _uri) public {
        uri = _uri;
    }

    // function tokenURI(
    //     uint256 tokenId
    // ) public view override returns (string memory) {
    //     _requireMinted(tokenId);

    //     string memory baseURI = _baseURI();
    //     return
    //         bytes(baseURI).length > 0
    //             ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
    //             : "";
    // }

    // function setTokenURI() public {
    //     _setTokenURI(
    //         totalMinted,
    //     "ipfs://QmeYhWhdX1ALiF5AeaHM5VwAR6XEUqL58kmdEx8GxxPkXk"
    //     );
    // }
}
