
pragma solidity ^0.8.0;

import { MY_NFT } from './NFTPROCESS.sol';
import { Auction } from './AUCTION.sol';

contract Transfer
{
    uint256 NFT_token_ID;
    uint256 IDNFT;
    address public artist;
    address public gallery_owner;
    address public topBidder;
    uint256 public topBid;
    address first_owner;
    address second_owner;
    uint256 lowest_bid;
    string art;
    uint256 public closetime;
    uint256 time_to_bid = 2 * 24 * 60 * 60; // converting time into seconds(2 Days)

    function generate_NFT(address _owner, string memory digital_art)
    private
    returns (uint256)
    {
        MY_NFT NFT_token = new MY_NFT();
        NFT_token_ID = NFT_token.mintNFT(_owner, digital_art);
        require(NFT_token_ID != 0);
        return NFT_token_ID;
    }

    function NFT_token_transfer(address from, address to, uint256 ID)
    private
    {
        MY_NFT NFT_token = new MY_NFT();
        NFT_token.token_transfer(from, to, ID);
    }

    function digital_asset_transfer_via_auction(address NFT_owner, uint256 ID)
    private
    returns (address)
    {
        Auction auction = new Auction();

        auction.Auction(time_to_bid, NFT_owner);

        while (block.timestamp <= closetime)
        {
            auction.bid();
        }

        auction.auctionClose();

        require(topBidder != address(0));
        require(topBidder != NFT_owner);
        require(topBid != 0);
        require(topBid > lowest_bid);

        NFT_token_transfer(NFT_owner, topBidder, ID);

        // 10 % royalty to the artist
        payable(artist).transfer(topBid / 10);

        return topBidder;
    }

    function main()
    public
    {
        IDNFT = generate_NFT(gallery_owner, art);

        first_owner = digital_asset_transfer_via_auction(gallery_owner, IDNFT);

        second_owner = digital_asset_transfer_via_auction(first_owner, IDNFT);
    }
}
