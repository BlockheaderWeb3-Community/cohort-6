// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/// @title Counter Contract
/// @author Goodness
/// @notice A simple counter contract that allows for incrementing, decrementing, and resetting a counter.
/// @dev Demonstrates state management, require conditions, and event emissions.

contract Counter {
    /// @notice A state variable to track the counter value.
    /// @dev The counter value is stored as an unsigned integer.
    uint public counter; 

    /// @notice Emitted when the counter is increased.
    /// @param newValue The new value of the counter after incrementing.
    /// @param timestamp The block timestamp when the counter was increased.
    event CountIncreased(uint256 newValue, uint256 timestamp);

    /// @notice Emitted when the counter is decreased.
    /// @param newValue The new value of the counter after decrementing.
    /// @param timestamp The block timestamp when the counter was decreased.
    event CountDecreased(uint256 newValue, uint256 timestamp);

    /// @notice Increases the counter by 1.
    /// @dev Ensures the counter does not exceed the maximum uint256 value.
    /// Emits a `CountIncreased` event.
    function increaseByOne() public { 
        require(counter < type(uint256).max, "can't go above the maximum value");
        counter++;
        emit CountIncreased(counter, block.timestamp);
    }

    /// @notice Increases the counter by a specified value.
    /// @dev Ensures the counter does not exceed the maximum uint256 value.
    /// Emits a `CountIncreased` event.
    /// @param _value The amount by which to increase the counter.
    function increaseByValue(uint _value) public { 
        require(counter < type(uint256).max, "can't go above the maximum value");
        counter += _value;
        emit CountIncreased(counter, block.timestamp);
    }

    /// @notice Decreases the counter by 1.
    /// @dev Ensures the counter does not go below 0.
    /// Emits a `CountDecreased` event.
    function decreaseByOne() public {
        require(counter > 0, "cannot decrease below 0");
        counter--;
        emit CountDecreased(counter, block.timestamp);   
    }

    /// @notice Decreases the counter by a specified value.
    /// @dev Ensures the counter does not go below 0.
    /// Emits a `CountDecreased` event.
    /// @param _value The amount by which to decrease the counter.
    function decreaseByValue(uint _value) public {
        require(counter >= _value, "cannot decrease below 0");
        counter -= _value;
        emit CountDecreased(counter, block.timestamp);        
    }

    /// @notice Resets the counter to 0.
    /// @dev Emits a `CountDecreased` event.
    function resetCount() public {
        counter = 0;
        emit CountDecreased(counter, block.timestamp);
    }

    /// @notice Returns the current value of the counter.
    /// @return The current counter value.
    function getCount() public view returns (uint) {
        return counter;
    }

    /// @notice Sets the counter to a specific value.
    /// @dev Emits a `CountIncreased` event.
    /// @param _num The new value to set the counter to.
    function stateChanging(uint _num) public {
        counter = _num;
        emit CountIncreased(counter, block.timestamp);
    }
}
