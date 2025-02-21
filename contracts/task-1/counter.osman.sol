// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Counter Contract by Osman

contract Counter {
    /// @notice The current value of the counter.
    uint public count;

    /// @notice Emitted when the counter is increased.
    /// @param amount The new value of the counter after the increase.

    event CountIncreased(uint amount);

    /// @notice Emitted when the counter is decreased.
    /// @param amount The new value of the counter after the decrease.
    event CountDecreased(uint amount);

    /// @notice Increases the counter by one.
    /// @dev Prevents overflow by checking if the new count exceeds the maximum value of uint256.
    /// @dev Emits the `CountIncreased` event.

    function increaseByOne() public {
        require(count < type(uint).max, "cannot increase beyond max uint");
        count += 1;
        emit CountIncreased(count);
    }

    /// @notice Increases the counter by a specified value.
    /// @dev check if the new count exceeds the maximum value of uint256.
    /// @param _value The value by which the counter should be increased.

    function increaseByValue(uint _value) public {
        require(count + _value >= count, "cannot increase beyond max uint");
        count += _value;
        emit CountIncreased(count);
    }

    /// @notice Decreases the counter by one.
    /// @dev Prevents underflow by checking if the count is already zero.
    /// @dev Emits the `CountDecreased` event.


    function decreaseByOne() public {
        require(count > 0, "Nice try, but you can't go below zero.");
        count -= 1;
        emit CountDecreased(count);
    }

    /// @notice Decreases the counter by a specified value.
    /// @dev Prevents underflow by checking if the count is greater than or equal to the specified value.
    /// @dev Emits the `CountDecreased` event.
    /// @param _value The value by which the counter should be decreased.


    function decreaseByValue(uint _value) public {
        require(count >= _value, "Nice try, but you can't go below zero.");
        count -= _value;
        emit CountDecreased(count);
    }

    /// @notice Resets the counter to zero.
    /// @dev Emits the `CountDecreased` event with the new count value as zero.


    function resetCount() public {
        count = 0;
        emit CountDecreased(count);
    }

    /// @notice Returns the current value of the counter.
    /// @return The current value of the counter.


    function getCount() public view returns (uint) {
        return count;
    }

    /// @notice Returns the maximum value of a uint256.
    /// @dev Utilizes an unchecked block to achieve this by underflowing a uint256.
    /// @return The maximum value of a uint256.

    function mxChecker() public pure returns (uint) {
        unchecked {
             return uint256(0) - 1;
        }
    }
}