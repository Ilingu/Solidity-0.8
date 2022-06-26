// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract RockPaperScissors {
  /* ERROR */
  error NoBet();
  error GameNotFound(bytes32 GameID);
  error TargetNotValid(address addr);
  error GameNotFinished(bytes32 GameID);
  error GameAlreadyExist(bytes32 GameID);
  error AlreadyPlayed(bytes32 GameID, address addr);
  error BetNotValid(bytes32 GameID, uint256 RightBet);
  error GameNotActive(bytes32 GameID, GameState state);
  error InvalidMove(bytes32 GameID, address addr, Move move);
  error UnauthorizedGame(bytes32 GameID, address wrongTarget);

  /* EVENT */
  event GameCreated(bytes32 indexed GameID, address indexed owner, uint256 bet);
  event GameStarted(bytes32 indexed GameID, address[2] players);
  event GameCompleted(bytes32 indexed GameID, address indexed winner);

  /* ENUM */
  enum GameState {
    Pending,
    Active
  }

  enum ResultState {
    Tie,
    Win,
    Lost
  }

  enum Move {
    None,
    Rock,
    Paper,
    Scissors
  }

  /* STRUCT */
  struct Game {
    address owner;
    address target;
    uint256 bet;
    GameState state;
  }

  struct FinishedGame {
    address owner;
    address Winner;
    address Loser;
    uint256 bet;
    ResultState state;
  }

  /* MAPPING */
  mapping(bytes32 => Game) public Games;
  mapping(bytes32 => mapping(address => Move)) public Moves;

  mapping(bytes32 => FinishedGame) public FinishedGames;

  /* MODIFIER */
  modifier CheckGame(bytes32 _GameID) {
    if (!_IsGame(_GameID)) revert GameNotFound(_GameID);
    _;
  }

  /* HELPERS */
  function _IsGame(bytes32 _GameID) private view returns (bool) {
    return
      Games[_GameID].owner != address(0) &&
      Games[_GameID].target != address(0) &&
      Games[_GameID].bet > 0;
  }

  /* METHODS */
  function CreateGame(address _target) external payable {
    if (msg.value < 1) revert NoBet();
    if (msg.sender == _target) revert TargetNotValid(_target);

    bytes32 GameID = keccak256(abi.encode(_target, msg.value, block.timestamp));
    if (_IsGame(GameID)) revert GameAlreadyExist(GameID);

    Game memory NewGame = Game({
      owner: msg.sender,
      target: _target,
      bet: msg.value,
      state: GameState.Pending
    });
    Games[GameID] = NewGame;

    emit GameCreated(GameID, msg.sender, msg.value);
  }

  function JoinGame(bytes32 GameID) external payable CheckGame(GameID) {
    Game storage game = Games[GameID]; // Query the game
    if (msg.sender != game.target) revert UnauthorizedGame(GameID, msg.sender);
    if (msg.value < game.bet) revert BetNotValid(GameID, game.bet);

    game.state = GameState.Active;

    if (msg.value > game.bet)
      payable(msg.sender).transfer(msg.value - game.bet); // Pay Back the diff

    address[2] memory players = [game.owner, game.target];
    emit GameStarted(GameID, players);
  }

  function MakeMove(bytes32 GameID, Move _move) external CheckGame(GameID) {
    Game storage game = Games[GameID]; // Querying the game

    if (game.state == GameState.Pending)
      revert GameNotActive(GameID, game.state);

    if (msg.sender != game.owner && msg.sender != game.target)
      revert UnauthorizedGame(GameID, msg.sender);

    if (Moves[GameID][msg.sender] != Move.None)
      revert AlreadyPlayed(GameID, msg.sender);

    if (_move == Move.None) revert InvalidMove(GameID, msg.sender, _move);
    Moves[GameID][msg.sender] = _move;
  }

  function CheckWinner(bytes32 GameID) external CheckGame(GameID) {
    Game storage game = Games[GameID]; // Querying the game

    if (game.state == GameState.Pending)
      revert GameNotActive(GameID, game.state);

    Move OwnerMove = Moves[GameID][game.owner];
    Move TargetMove = Moves[GameID][game.target];
    if (OwnerMove == Move.None || TargetMove == Move.None)
      revert GameNotFinished(GameID);

    FinishedGame memory _finishedGame;
    _finishedGame.bet = game.bet;
    _finishedGame.owner = game.owner;

    if (OwnerMove == TargetMove) {
      _finishedGame.state = ResultState.Tie; // Tie
      _finishedGame.Winner = address(0);
      _finishedGame.Loser = address(0);
    } else if (
      (OwnerMove == Move.Rock && TargetMove == Move.Scissors) ||
      (OwnerMove == Move.Paper && TargetMove == Move.Rock) ||
      (OwnerMove == Move.Scissors && TargetMove == Move.Paper)
    ) {
      _finishedGame.state = ResultState.Win; // Owner Wins
      _finishedGame.Winner = game.owner; // Owner Wins
      _finishedGame.Loser = game.target;
    } else {
      _finishedGame.state = ResultState.Lost; // Owner Lost
      _finishedGame.Winner = game.target; // Target Wins
      _finishedGame.Loser = game.owner;
    }

    if (_finishedGame.state == ResultState.Tie) {
      payable(game.owner).transfer(game.bet); // Pay back to owner
      payable(game.target).transfer(game.bet); // Pay back to target
    } else payable(_finishedGame.Winner).transfer(game.bet * 2); // Pay Bet to Winner

    FinishedGames[GameID] = _finishedGame; // Archive Game

    // Delete Game
    OwnerMove = Move.None;
    TargetMove = Move.None;
    delete Games[GameID];

    emit GameCompleted(GameID, _finishedGame.Winner);
  }
}
