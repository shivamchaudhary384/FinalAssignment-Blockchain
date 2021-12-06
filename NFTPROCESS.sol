
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MY_NFT is ERC721URIStorage, Ownable
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("MY_NFT", "NFT") {}

    function mintNFT(address recipient, string memory tokenURI)
    public onlyOwner
    returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function token_transfer(address from, address to, uint256 ID)
    public onlyOwner
    {
        safeTransferFrom(from, to, ID);
    }
}
