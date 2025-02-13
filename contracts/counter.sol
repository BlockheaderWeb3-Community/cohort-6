// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/// @title Counter Contract
/// @author Enyinnaya Wisdom
/// @notice A counter contract that allows for incrementing and decrementing a counter.
/// @dev This contract demonstrates basic state management and event emission.
contract Counter {
    /// @notice The current value of the counter.
    uint256 public counter;

    /// @notice Emitted when the counter is increased.
    /// @param newValue The new value of the counter after incrementing.
    /// @param timestamp The block timestamp when the counter was increased.
    event CountIncreased(uint256 newValue, uint256 timestamp);

    /// @notice Emitted when the counter is decreased.
    /// @param newValue The new value of the counter after decrementing.
    /// @param timestamp The block timestamp when the counter was decreased.
    event CountDecreased(uint256 newValue, uint256 timestamp);

    /// @notice Increases the counter by 1.
    /// @dev Uses Solidity 0.8.0+ built-in overflow protection.
    function increaseByOne() public {
        require(counter < type(uint256).max, "Counter overflow");
        counter++;
        emit CountIncreased(counter, block.timestamp);
    }

    /// @notice Increases the counter by a specified value.
    /// @dev Prevents overflow by ensuring `counter + _value` does not exceed `uint256.max`.
    /// @param _value The amount by which to increase the counter.
    function increaseByValue(uint256 _value) public {
        require(counter + _value >= counter, "Counter overflow");
        counter += _value;
        emit CountIncreased(counter, block.timestamp);
    }

    /// @notice Decreases the counter by 1.
    /// @dev Ensures the counter does not go below 0.
    function decreaseByOne() public {
        require(counter > 0, "Counter underflow");
        counter--;
        emit CountDecreased(counter, block.timestamp);
    }

    /// @notice Decreases the counter by a specified value.
    /// @dev Ensures `_value` is not greater than the current counter value.
    /// @param _value The amount by which to decrease the counter.
    function decreaseByValue(uint256 _value) public {
        require(counter >= _value, "Counter underflow");
        counter -= _value;
        emit CountDecreased(counter, block.timestamp);
    }

    /// @notice Resets the counter to 0.
    /// @dev This function sets `counter` to zero and emits a `CountDecreased` event.
    function resetCount() public {
        counter = 0;
        emit CountDecreased(counter, block.timestamp);
    }

    /// @notice Returns the current value of the counter.
    /// @dev This is a getter function for the `counter` state variable.
    /// @return The current value of the counter.
    function getCount() public view returns (uint256) {
        return counter;
    }

    /// @notice Sets the counter to a specific value.
    /// @dev Updates `counter` to `_num` and emits a `CountIncreased` event.
    /// @param _num The new value to set the counter to.
    function stateChanging(uint256 _num) public {
        counter = _num;
        emit CountIncreased(counter, block.timestamp);
    }
}
