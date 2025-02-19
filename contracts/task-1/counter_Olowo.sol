// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

/// @title A counter contract
/// @author Darey Olowo
/// @notice You can use this contract for basic operation
/// @dev All function calls are currently implemented without side effects
/// @custom:experimental This is an experimental contract.

contract Counter {
    /// @notice the count defualt value
    uint public count = 0;

    /// @dev Event emitted when the count is increased.
    event CountIncreased(uint newValue);
    /// @dev Event emitted when the count is decreased.
    event CountDecreased(uint newValue);
    /// @dev Event emitted when the count is increased by input value.
    event CountIncreasedByValue(uint value, uint newTotal);
    /// @dev Event emitted when the count is decreased by input value.
    event CountDecreasedByValue(uint value, uint newTotal);
    /// @dev Event emitted when the count is reset to defualt.
    event CountReset(uint newValue);

    /// @dev Function to increase count by one.
    /// @dev Prevents overflow.
    function increaseByOne() public {
        uint maxValue = getMaxUint256();
        require(count < maxValue, "cannot increase beyond max uint");
        count++;
        emit CountIncreased(count);
    }

    /// @dev Function to increase count by input value.
    /// @dev Prevents overflow.
    function increaseByValue(uint _value) public {
        uint maxValue = getMaxUint256();
        require(_value > 0);
        require(count + _value <= maxValue, "cannot increase beyond max uint");
        count += _value;
        emit CountIncreasedByValue(_value, count);
    }

    /// @dev Function to decrease count by one.
    /// @dev Prevents underflow.
    function decreaseByOne() public {
        require(count > 0, "cannot decrease below 0");
        count--;
        emit CountDecreased(count);
    }

    /// @dev Function to decrease count by input value.
    /// @dev Prevents underflow.
    function decreaseByValue(uint _value) public {
        require(_value > 0);
        require(count >= _value, "cannot decrease below 0");
        count -= _value;
        emit CountDecreasedByValue(_value, count);
    }

    /// @dev Function to reset count to zero.
    /// @dev count state must be greater then zero.
    function resetCount() public {
        require(count > 0);
        count = 0;
        emit CountReset(count);
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
