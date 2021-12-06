
pragma solidity ^0.8.0;

contract Auction
{
    //Intialization.
    address public beneficiaryAddress;
    uint256 public closetime;

    // Current state of auction.
    address public topBidder;
    uint256 public topBid;

    uint256 public lowest_bid = 1; // lowest bid of 1 eth

    
    bool auctionComplete;

    
    event topBidIncreased(address bidder, uint256 bidAmount);
    event auctionResult(address winner, uint256 bidAmount);

    
    function Auction (uint256 _biddingTime, address _beneficiary)
    public
    {
        beneficiaryAddress = _beneficiary;
        closetime = block.timestamp + _biddingTime;
    }

    
    function bid()
    public
    payable
    {
        

        // Checking if the address of the bidder is valid
        require(topBidder != address(0));

        // Revert the call in case the bidding time period is over.
        
        require(block.timestamp <= closetime);

        
        require(topBid > lowest_bid);
        require(msg.value > topBid);

        topBidder = msg.sender;
        topBid = msg.value;
        emit topBidIncreased(msg.sender, msg.value);
    }

    
    function auctionClose()
    public
    {
        

        // 1. Conditions
        require(block.timestamp >= closetime); // auction did not yet end
        require(!auctionComplete); // this function has already been called

        // 2. Effects
        auctionComplete = true;
        emit auctionResult(topBidder, topBid);

        // 3. Interaction
        payable(beneficiaryAddress).transfer(topBid);
    }
}