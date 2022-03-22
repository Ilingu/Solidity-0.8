# Solidity Wiki Book

## Global (built-in)

- `constructor`: not mandatory, call once at deploy time
- `public`: can be call/access by the code and the outside world (other contract or EOA)
  - Default visibility for Function / Getter automatically create for public variable
- `private`: can only be call/access by the code (SC) via Getter Func
- `internal`: like `private` but they can also be access by derived SC (`private` limit at the scale of the SC defined in wheras `internal` limit at the scale of all the project SC)
  - Default visibility for state variables
- `external`: can only be call/access by the outside world
  - Not available for variables
  - Use less gas that public func
- `constant`: a simple constant (like JS)
- `immutable`: like a constant but can only be change once in the constructor
- `pure`: doesn't modify blockchain, and cannot read storage (couper du monde)
- `view`: doesn't modify blockchain, just read storage variables
- `payable`: Give the ability to the func to manipulate ether and addIt to SC balance
- `plain`: Inverse of `payable` -> nonpayable
- `struct`: like Interface in TS
- `enum`: like Enum in TS, (variable assign to number, for readability)
- `require()`: The `require()` condition is require to continute executing the code. (e.g: `require(msg.sender == owner);` require that the tx sender is the owner, if true the code can continute executing, otherwise the code stop executing)
- `modifier()`: like an Middleware in NodeJS (piece of code, most of the case a `require()`) that is execute before the func
- `event`: response back to the front-end the state of the contract (e.g Is the transfer was successful)
  - Only `external` (cannot be access winthin the SC or derived SC)
  - You can just `emit` it.
- `delete`: Fake friend: it ONLY reset a var to it's original value, it DO NOT remove the data.
  > uint[] nums = [1, 2, 3] --> delete nums[1] --> [1, 0, 3] (Just reset 2, to the uint's default value i.e: 0)
  >
  > > For Struct/mapping, it reset all the data to their default vals

### Solidity Global Variables

- `msg`: Global variable which contains the information the tx/account/call

  - `.value`: the amount of wei sent
  - `.sender`: the address of the sender of the tx
  - `.data`: data of tx or the call execution of SC func

- `gasleft`: remaining gas of the current tx

- `block`: Global variable which contains block info

  - `.timestamp: "now"`
  - `.number`
  - `.difficulty`
  - `.gaslimit`

- `this`: The current contract address (ex: `address(this).balance` return the contract balance)
- `tx.gasprice`: Gas price of tx

## Payable Func/Contract Balance

A Contract can have ETH balance only if there is a payable function defined (See _PayableContract.sol_):

- `receive()`: only receive eth, and add to Contract balance (e.g: the send btn of MetaMask will trigger receive())
- `fallback()`: if tx call a non existing function, the fallback is trigger and will receive the tx eth (otherwise the ETH will be lost forever)
  > These two func are always **external** and **payable**, cannot have args or return something
- `payable` func: like `receive()` but execute the function code

## Contract Address

- `address` is a variable **type**, and an address var can do this:

  - `.balance`: current balance of the address
  - `.transfer()`: send ETH (safest way to manipulate ETH) **Only for `payable address`**
    > **should always be used**
  - `.send()`: low-level `.transfer()` (more risky) **Only for `payable address`**
    > If execution fails, the contract will not stop and send() will return false

- `payable address`: Address with the ability to have and receive eth
- `plain address`: Inverse of `payable` -> nonpayable address

## Mapping

- `mapping(keyType => valType)`: **key -> value**: Like JS Object
- `mapping VS array`: mapping has always the same lookup time no matter size whereas Arrays have linear search time

### # Rules

> 1. key/value always of the same defined type
>
> 2. Mapping **isn't iterable** (no forloop of the obj)
>
> 3. _keys_ cannot be **mapping**, **dynamic array**, **enum/struct** whereas _value_ can be of any types
>
> 4. Keys aren't save into the mapping
>
> 5. If key doesn't exist we get the default value of his type
>
> 6. Always saved in Storage

## Array

### TODO

## Struct

### TODO

## Inheritance

- `is`: allow to accept a derived contract
- `abstract`: describe the shape/design/behaviour of an SC (a `abstract` SC cannot be deployed)
- `virtual`: declare the function shape in `abstract` contract, real contract have to implement it with `override`
- `override`: overwrite the function shape in an `abstract` SC
- `interfaces`: like `abstract` (shape of SC) but they can't have any function code implemented
  - All declared func must be `external`
  - Cannot declare `constructor()`
  - Cannot declare state variables
  - Cannot inherit from other SC, but can inherit from other interfaces

## Storage VS Memory

- `storage`: Copy the pointer (path to original variable), the original variable **is link** to the storage copy variable, so if we made change in the storage copy variable the real variable will also do the change. When the function execution end the var is unloaded (localVariables) BUT all update are saved.
- `memory`: Copy/Create the variable in memory, the original variable **is not link** to the memory copy variable, the memory copy is, a totally apart variable, when the function execution end the var is unloaded (localVariables) and all values/changes are gone

## Type Conversion

To convert linked type, e.g byte to string

- `string(bytes_variable)`: will convert the bytes_variable to a string
- `address(variable_transformable_to_address)`: will transform to an address (e.g: `this`: `address(this)`)
- `payable(address_var)`: convert to a payable address
- More Generally: `output_type(variable_to_transform)`

## Int

- `int8 to int256`: **+/- values** (int is alias for int256)
- `uint8 to uint256`: **only + values** (uint is alias for uint256)
  > uint8: (2^8 - 1) = 255 values -> uintX / intX: (2^Y - 1) values
  > Overflow: when the max value is exceded (uint8 x = 255; x += 1; x will return 0)
- `FLOAT/DOUBLE`: **not yet supported** in solidity (0.000000001 ETH = 1000000000 wei)

## Bytes/String

- `bytes1 to bytes32`: store string in hex format of bytes size
  > 1bytes = 1 character
  > bytes1 = "ab" -> 2char so 2bytes, so bytes1 will be not enough -> ERROR
- `string VS bytes`: cannot add/get/getLength element to/from string whereas bytes yes (In fact, bytes is a array)
