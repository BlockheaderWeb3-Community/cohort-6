// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/// @title Counter Contract
/// @notice This contract manages a simple numerical counter with functions to increase, decrease, and reset the counter.
/// @dev Prevents overflow and underflow with require statements.
contract Counter {
    /// @notice The current value of the counter.
    uint public count;
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/// @title Counter Contract
/// @notice This contract manages a simple numerical counter with functions to increase, decrease, and reset the counter.
/// @dev Prevents overflow and underflow with require statements.
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
    /// @dev Prevents overflow using require.
    function increaseByOne() public {
        require(count < type(uint).max, "cannot increase beyond max uint");
        count++;
        emit CountIncreased(count, block.timestamp);
    }

    /// @notice Increases the counter by a given value.
    /// @dev Prevents overflow by checking if count + _value exceeds type(uint).max.
    /// @param _value The amount to increase the counter by.
    function increaseByValue(uint _value) public {
        require(count <= type(uint).max - _value, "cannot increase beyond max uint");
        count += _value;
        emit CountIncreased(count, block.timestamp);
    }

    /// @notice Decreases the counter by one.
    /// @dev Prevents underflow by ensuring count is greater than 0.
    function decreaseByOne() public {
        require(count > 0, "cannot decrease below 0");
        count--;
        emit CountDecreased(count, block.timestamp);
    }

    /// @notice Decreases the counter by a given value.
    /// @dev Prevents underflow by ensuring count is greater than or equal to _value.
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
    /// @dev Uses an unchecked block to return the max uint256 value.
    /// @return The maximum value of a uint256.
    function getMaxUint256() public pure returns (uint) {
        unchecked {
            return type(uint256).max;
        }
    }
}

    /// @notice Emitted when the count is increased.
    /// @param amount The new value of the counter after the increase.
    /// @param when The timestamp of the increase.
    event CountIncreased(uint amount, uint256 when);

    /// @notice Emitted when the count is decreased.
    /// @param amount The new value of the counter after the decrease.
    /// @param when The timestamp of the decrease.
    event CountDecreased(uint amount, uint256 when);

    /// @notice Increases the counter by one.
    /// @dev Prevents overflow using require.
    function increaseByOne() public {
        require(count < type(uint).max, "cannot increase beyond max uint");
        count++;
        emit CountIncreased(count, block.timestamp);
    }

    /// @notice Increases the counter by a given value.
    /// @dev Prevents overflow by checking if count + _value exceeds type(uint).max.
    /// @param _value The amount to increase the counter by.
    function increaseByValue(uint _value) public {
        require(count <= type(uint).max - _value, "cannot increase beyond max uint");
        count += _value;
        emit CountIncreased(count, block.timestamp);
    }

    /// @notice Decreases the counter by one.
    /// @dev Prevents underflow by ensuring count is greater than 0.
    function decreaseByOne() public {
        require(count > 0, "cannot decrease below 0");
        count--;
        emit CountDecreased(count, block.timestamp);
    }

    /// @notice Decreases the counter by a given value.
    /// @dev Prevents underflow by ensuring count is greater than or equal to _value.
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
    /// @dev Uses an unchecked block to return the max uint256 value.
    /// @return The maximum value of a uint256.
    function getMaxUint256() public pure returns (uint) {
        unchecked {
            return type(uint256).max;
        }
    }
}