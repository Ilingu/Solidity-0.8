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
contract DutchAuction {
  uint256 private constant DURATION = 7 days;

  IERC721 public immutable nft;
  uint256 public immutable nftId;

  address payable public immutable seller;
  uint256 public immutable startingPrice;
  uint256 public immutable startAt;
  uint256 public immutable expireAt;
  uint256 public immutable discountRate;

  constructor(
    uint256 _startingPrice,
    uint256 _discountRate,
    address _nft,
    uint256 _nftId
  ) {
    seller = payable(msg.sender);
    startingPrice = _startingPrice;
    discountRate = _discountRate;
    startAt = block.timestamp;
    expireAt = block.timestamp + DURATION;

    require(
      _startingPrice >= _discountRate * DURATION,
      "startingPrice < discout"
    );

    nft = IERC721(_nft);
    nftId = _nftId;
  }

  function getPrice() public view returns (uint256) {
    uint256 timeElapsed = block.timestamp - startAt;
    uint256 discount = discountRate * timeElapsed;
    return startingPrice - discount;
  }

  function buy() external payable {
    require(block.timestamp < expireAt, "auction expired");

    uint256 price = getPrice();
    require(msg.value >= price, "ETH < price");

    nft.transferFrom(seller, msg.sender, nftId);

    uint256 refund = msg.value - price;
    if (refund > 0) payable(msg.sender).transfer(refund);

    selfdestruct(seller); // Kill the contract
  }
}
