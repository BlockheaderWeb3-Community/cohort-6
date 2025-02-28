# Assignment1
here's link to [assignment 1](../../contracts/Assignment1/counter.Uka.sol)

# Counter Smart Contract

## Overview
The **Counter** smart contract is a simple contract that allows users to manage a counter value by incrementing, decrementing, resetting, and setting a specific value. It demonstrates Solidity concepts such as state management, require conditions, and event emissions.

## Features
- **Increment Counter**: Increase the counter by 1 or a specified value.
- **Decrement Counter**: Decrease the counter by 1 or a specified value.
- **Reset Counter**: Reset the counter to zero.
- **Set Counter Value**: Directly set the counter to a specific number.
- **Event Emissions**: Emits events when the counter is modified.

## Smart Contract Details
- **Author**: Goodness
- **Compiler Version**: Solidity 0.8.24
- **License**: UNLICENSED

## Functions
### 1. `increaseByOne()`
Increments the counter by 1.
- Emits `CountIncreased` event.
- Ensures counter does not exceed `uint256` max value.

### 2. `increaseByValue(uint _value)`
Increments the counter by a specified `_value`.
- Emits `CountIncreased` event.
- Ensures counter does not exceed `uint256` max value.

### 3. `decreaseByOne()`
Decrements the counter by 1.
- Emits `CountDecreased` event.
- Ensures counter does not go below 0.

### 4. `decreaseByValue(uint _value)`
Decrements the counter by a specified `_value`.
- Emits `CountDecreased` event.
- Ensures counter does not go below 0.

### 5. `resetCount()`
Resets the counter to zero.
- Emits `CountDecreased` event.

### 6. `getCount()`
Returns the current counter value.
- `view` function (read-only).

### 7. `stateChanging(uint _num)`
Sets the counter to a specific value.
- Emits `CountIncreased` event.

## Events
### `CountIncreased(uint256 newValue, uint256 timestamp)`
- Triggered when the counter is increased.
- Logs the new counter value and block timestamp.

### `CountDecreased(uint256 newValue, uint256 timestamp)`
- Triggered when the counter is decreased.
- Logs the new counter value and block timestamp.

## Deployment
1. Deploy the contract using **Remix**, **Hardhat**, or **Truffle**.
2. Interact with the contract using **Ethers.js** or **Web3.js**.
3. Ensure proper gas estimation when calling state-changing functions.

## License
This contract is licensed as **UNLICENSED**.

## Author
**Goodness**
