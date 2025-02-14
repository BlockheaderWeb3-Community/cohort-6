// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Counter {
    /// @notice The current value of the counter.
    uint public count;

    /// @notice Emitted when the count is increased.
    /// @param amount The new value of the counter after the increase.
    /// @param when The timestamp of the increase.
    event CountIncreased(uint amount, uint256 when);

    /// @notice Emitted when the count is decreased.
    /// @param amount The new value of the counter after the decrease.
    /// @param when The timestamp of the decrease.
    event CountDecreased(uint amount, uint256 when);

    /// @notice Increases the counter by one.
    /// @dev Prevents overflow by checking if the count is less than the maximum value of uint256.
    /// Emits a `CountIncreased` event.
    function increaseByOne() public {
        require(count < type(uint256).max, "cannot increase beyond max uint");
        count++;
        emit CountIncreased(count, block.timestamp);
    }

    /// @notice Increases the counter by a given value.
    /// @dev Prevents overflow by ensuring the new count does not exceed the maximum value of uint256.
    /// Emits a `CountIncreased` event.
    /// @param _value The amount to increase the counter by.
    function increaseByValue(uint _value) public {
        require(count + _value >= count, "cannot increase beyond max uint"); // Prevents overflow
        count += _value;
        emit CountIncreased(count, block.timestamp);
    }

    /// @notice Decreases the counter by one.
    /// @dev Prevents underflow by ensuring the count is greater than 0.
    /// Emits a `CountDecreased` event.
    function decreaseByOne() public {
        require(count > 0, "cannot decrease below 0");
        count--;
        emit CountDecreased(count, block.timestamp);
    }

    /// @notice Decreases the counter by a given value.
    /// @dev Prevents underflow by ensuring the count does not go below 0.
    /// Emits a `CountDecreased` event.
    /// @param _value The amount to decrease the counter by.
    function decreaseByValue(uint _value) public {
        require(count >= _value, "cannot decrease below 0");
        count -= _value;
        emit CountDecreased(count, block.timestamp);
    }

    /// @notice Resets the counter to zero.
    /// @dev Emits a `CountDecreased` event with the new count value (0).
    function resetCount() public {
        count = 0;
        emit CountDecreased(count, block.timestamp);
    }

    /// @notice Returns the current value of the counter.
    /// @return The current value of the counter.
    function getCount() public view returns (uint) {
        return count;
    }

    /// @notice Returns the maximum value of a uint256.
    /// @dev Uses an unchecked block to achieve this by underflowing a uint256.
    /// @return The maximum value of a uint256.
    function getMaxUint256() public pure returns (uint) {
        unchecked {
            return type(uint256).max;
        }
    }
}