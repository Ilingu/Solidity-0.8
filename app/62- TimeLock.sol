// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TimeLock {
  error NotOwnerError();
  error AlreadyQueuedError(bytes32 txId);
  error TimestampNotInRangeError(uint256 blockTimestamp, uint256 timestamp);
  error NotQueuedError(bytes32 txId);
  error TimestampNotPassedError(uint256 blockTimestamp, uint256 timestamp);
  error TimestampExpiredError(uint256 blockTimestamp, uint256 ExpireAt);
  error TxFailedError();

  event Queue(
    bytes32 indexed txId,
    address indexed target,
    uint256 value,
    string func,
    bytes data,
    uint256 timestamp
  );
  event Execute(
    bytes32 indexed txId,
    address indexed target,
    uint256 value,
    string func,
    bytes data,
    uint256 timestamp
  );
  event Cancel(bytes32 indexed txId);

  uint256 public constant MIN_DELAY = 10; // in prod it's a few days
  uint256 public constant MAX_DELAY = 1000; // in prod it's ~1 month
  uint256 public constant GRACE_PERIOD = 100; // When tx is ready to be executed, you have max 100s to execute it, after it's expired

  address public owner;
  mapping(bytes32 => bool) public queued;

  constructor() {
    owner = msg.sender;
  }

  receive() external payable {}

  modifier onlyOwner() {
    if (msg.sender != owner) {
      revert NotOwnerError();
    }
    _;
  }

  function getTxId(
    address _target,
    uint256 _value,
    string calldata _func,
    bytes calldata _data,
    uint256 _timestamp
  ) public pure returns (bytes32 txId) {
    return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
  }

  function queue(
    address _target,
    uint256 _value,
    string calldata _func,
    bytes calldata _data,
    uint256 _timestamp
  ) external onlyOwner {
    // create tx id
    bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
    // check tx id unique
    if (queued[txId]) {
      revert AlreadyQueuedError(txId);
    }
    // check timestamp
    if (
      _timestamp < block.timestamp + MIN_DELAY ||
      _timestamp > block.timestamp + MAX_DELAY
    ) {
      revert TimestampNotInRangeError(block.timestamp, _timestamp);
    }
    // queue tx
    queued[txId] = true;

    emit Queue(txId, _target, _value, _func, _data, _timestamp);
  }

  function execute(
    address _target,
    uint256 _value,
    string calldata _func,
    bytes calldata _data,
    uint256 _timestamp
  ) external payable onlyOwner returns (bytes memory) {
    bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
    // check tx is queued
    if (!queued[txId]) {
      revert NotQueuedError(txId);
    }
    // check block.timestamp > _timestamp
    if (block.timestamp < _timestamp) {
      revert TimestampNotPassedError(block.timestamp, _timestamp);
    }
    if (block.timestamp > _timestamp + GRACE_PERIOD) {
      revert TimestampExpiredError(block.timestamp, _timestamp + GRACE_PERIOD);
    }
    // delete tx from queue
    delete queued[txId];

    bytes memory data;
    if (bytes(_func).length > 0) {
      data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
    } else {
      data = _data;
    }
    // execute the tx
    (bool ok, bytes memory res) = _target.call{ value: _value }(data);
    if (!ok) {
      revert TxFailedError();
    }

    emit Execute(txId, _target, _value, _func, _data, _timestamp);
    return res;
  }

  function cancel(bytes32 _txId) external onlyOwner {
    if (!queued[_txId]) {
      revert NotQueuedError(_txId);
    }

    delete queued[_txId];
    emit Cancel(_txId);
  }
}

contract TestTimeLock {
  address public timeLock;

  constructor(address _timeLock) {
    timeLock = _timeLock;
  }

  function test() external {
    require(msg.sender == timeLock);
    // more code here such as
    // - upgrade contract
    // - transfer funds
    // - switch price oracle
  }
}
