// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC721 {
  function transferFrom(
    address _from,
    address _to,
    uint256 _nftId
  ) external;
}

/// @notice DO NOT! in ANY CASES use this contract in production! his timing system is based on block.timestamp, however it's really bad practice and not realiable at all, use a Oracle instead.
contract EnglishAuction {
  event Start();
  event Bid(address indexed sender, uint256 amount);
  event Withdraw(address indexed bidder, uint256 amount);
  event End(address indexed winner, uint256 amount);

  IERC721 public immutable nft;
  uint256 public immutable nftId;

  address public immutable seller;
  uint32 public endAt;
  bool public started;
  bool public ended;

  address public highestBidder;
  uint256 public highestBid;
  mapping(address => uint256) public bids;

  constructor(
    address _nft,
    uint256 _nftId,
    uint256 _startingBid
  ) {
    nft = IERC721(_nft);
    nftId = _nftId;
    seller = payable(msg.sender);
    highestBid = _startingBid;
  }

  function start() external {
    require(msg.sender == seller, "not seller");
    require(!started, "started");

    started = true;
    endAt = uint32(block.timestamp + 60); // set to 60s (because I don't want to wait days -__-)
    nft.transferFrom(seller, address(this), nftId); // Transfer ownership of nft to this contract

    emit Start();
  }

  function bid() external payable {
    require(started, "not started");
    require(block.timestamp < endAt, "ended");
    require(msg.value > highestBid, "value < highestBid");

    if (highestBidder != address(0)) {
      bids[highestBidder] += highestBid; // Set the former higestbidder balance to his bid, so that he can withdraw it
    }

    highestBid = msg.value;
    highestBidder = msg.sender;

    emit Bid(msg.sender, msg.value);
  }

  function withdraw() external {
    uint256 bal = bids[msg.sender];
    bids[msg.sender] = 0; // is eq to: delete bids[msg.sender];
    /// Note that we set bids at 0 before sending the ETH to protect from Reentrency attacks
    payable(msg.sender).transfer(bal);

    emit Withdraw(msg.sender, bal);
  }

  /// Function that can be called by anyone for the seller to not lose his NFT
  function end() external {
    require(started, "!started");
    require(!ended, "Already ended");
    require(block.timestamp >= endAt, "not yet ended");

    ended = true;
    if (highestBidder != address(0)) {
      nft.transferFrom(address(this), highestBidder, nftId);
      payable(seller).transfer(highestBid);
    } else {
      nft.transferFrom(address(this), seller, nftId);
    }

    emit End(highestBidder, highestBid);
  }
}
