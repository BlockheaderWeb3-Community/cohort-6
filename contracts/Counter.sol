// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
import "hardhat/console.sol";

/// @title Counter Contract
/// @author BlockHeaderWeb3
/// @notice This contract provides a simple counter with basic operations.
contract Counter {
    /// @dev Stores the current count value.
    uint public count;

    /// @dev Event emitted when the count is increased.
    event CountIncreased(uint amount, uint when);
    /// @dev Event emitted when the count is decreased.
    event CountDecreased(uint amount, uint when);

    /// @dev Function to increase count by one.
    /// @dev Prevents overflow.
    function increaseByOne() public {
        require(count < type(uint).max, "cannot increase beyond max uint");
        count += 1;
        emit CountIncreased(count, block.timestamp);
    }

    /// @dev Function to increase count by a given value.
    /// @dev Prevents overflow.
    function increaseByValue(uint _value) public {
        require(count + _value <= getMaxUint256(), "cannot increase beyond max uint");
        count += _value;
        emit CountIncreased(count, block.timestamp);
    }

    /// @dev Function to decrease count by one.
    /// @dev Prevents underflow.
    function decreaseByOne() public {
        require(count > 0, "cannot decrease below 0");
        count -= 1;
        emit CountDecreased(count, block.timestamp);
    }

    /// @dev Function to decrease count by a given value.
    /// @dev Prevents underflow.
    function decreaseByValue(uint _value) public {
        require(count >= _value, "cannot decrease below 0");
        count -= _value;
        emit CountDecreased(count, block.timestamp);
    }

    /// @dev Function to reset count to zero.
    function resetCount() public {
        count = 0;
        emit CountDecreased(count, block.timestamp);
    }

    /// @dev Function to get the current count value.
    /// @return The current count value.
    function getCount() public view returns (uint) {
        return count;
    }

    /// @dev Function to return uint 256 max through underflow using unchecked block.
    /// @return The maximum value of uint256.
    function getMaxUint256() public pure returns (uint) {
        unchecked {
            return uint256(0) - 1;
        }
    }
}
