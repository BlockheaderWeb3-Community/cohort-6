// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/// @title Counter Contract
/// @notice A simple contract that implements a counter with increase, decrease and reset functionality
contract Counter {
    /// @notice The current value of the counter
    uint public count;

    /// @notice Emitted when the counter value is increased
    /// @param amount The new value of the counter
    /// @param when The timestamp when the increase occurred
    event CountIncreased(uint amount, uint when);

    /// @notice Emitted when the counter value is decreased
    /// @param amount The new value of the counter
    /// @param when The timestamp when the decrease occurred
    event CountDecreased(uint amount, uint when);

    /// @notice Increases the counter by one
    /// @dev Reverts if the operation would cause an overflow
    function increaseByOne() public {
        require(count < type(uint).max, "cannot increase beyond max uint");
        count += 1;
        emit CountIncreased(count, block.timestamp);
    }

    /// @notice Increases the counter by a specified value
    /// @param _value The amount to increase the counter by
    /// @dev Reverts if the operation would cause an overflow
    function increaseByValue(uint _value) public {
        require(count + _value <= type(uint).max, "cannot increase beyond max uint");
        count += _value;
        emit CountIncreased(count, block.timestamp);
    }

    /// @notice Decreases the counter by one
    /// @dev Reverts if the operation would cause an underflow
    function decreaseByOne() public {
        require(count > 0, "cannot decrease below 0");
        count -= 1;
        emit CountDecreased(count, block.timestamp);
    }

    /// @notice Decreases the counter by a specified value
    /// @param _value The amount to decrease the counter by
    /// @dev Reverts if the operation would cause an underflow
    function decreaseByValue(uint _value) public {
        require(count >= _value, "cannot decrease below 0");
        count -= _value;
        emit CountDecreased(count, block.timestamp);
    }

    /// @notice Resets the counter to zero
    function resetCount() public {
        uint oldCount = count;
        if (oldCount != 0) {
            count = 0;
            emit CountDecreased(count, block.timestamp);
        }
    }

    /// @notice Returns the current value of the counter
    /// @return The current counter value
    function getCount() public view returns (uint) {
        return count;
    }

    /// @notice Returns the maximum value of uint256
    /// @return The maximum value that can be stored in a uint256
    /// @dev Uses unchecked arithmetic to intentionally underflow and get max uint
    function getMaxUint256() public pure returns (uint) {
        uint max;
        unchecked {
            max = 0 - 1;
        }
        return max;
    }
}
