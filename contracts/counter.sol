// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
/**
* @title Counter
* @author Enyinnaya Wisdom
* @notice a counter contract that allows for incrementing and decrementing a counter
* @dev This contract demonstrates basic state management and event emission
*/
contract Counter {
    uint public counter;
        /**
     * @notice Emitted when the counter is increased.
     * @param newValue The new value of the counter after incrementing.
     * @param timestamp The block timestamp when the counter was increased.
     */
    event CountIncreased(uint256 newValue, uint256 timestamp);

    /**
     * @notice Emitted when the counter is decreased.
     * @param newValue The new value of the counter after decrementing.
     * @param timestamp The block timestamp when the counter was decreased.
     */
    event CountDecreased(uint256 newValue, uint256 timestamp);
    /**
     * @notice Increases the counter by 1.
     * @dev This function increments the counter and emits a `CountIncreased` event.
     * It automatically checks for overflow in Solidity 0.8.0+.
     */
    function increaseByOne() public {
        require(counter < type(uint256).max, "cannot increase beyond max uint");
        counter ++;
        emit CountIncreased(counter, block.timestamp);
    }
     /**
     * @notice Increases the counter by a specified value.
     * @dev This function increments the counter by `_value` and emits a `CountIncreased` event.
     * It reverts if the counter would exceed the maximum value for `uint256`.
     * @param _value The amount by which to increase the counter.
     */
    function increaseByValue(uint _value) public {
        require(counter < type(uint256).max, "cannot increase beyond max uint");
        counter += _value;
        emit CountIncreased(counter, block.timestamp);

    }
     /**
     * @notice Decreases the counter by 1.
     * @dev This function decrements the counter and emits a `CountDecreased` event.
     * It reverts if the counter is already 0 to prevent underflow.
     */
    function decreaseByOne() public {
        require(counter > 1, "cannot decrease below 0");
        counter --;
        emit CountDecreased(counter, block.timestamp);        
    }

      /**
     * @notice Decreases the counter by a specified value.
     * @dev This function decrements the counter by `_value` and emits a `CountDecreased` event.
     * It reverts if the counter would go below 0.
     * @param _value The amount by which to decrease the counter.
     */
    function decreaseByValue(uint _value) public {
        require(counter > _value, "cannot decrease below 0");
        counter -= _value;
        emit CountDecreased(counter, block.timestamp);        
    }
     /**
     * @notice Resets the counter to 0.
     * @dev This function sets the counter to 0 and emits a `CountDecreased` event.
     */
    function resetCount() public {
        counter = 0;
        emit CountDecreased(counter, block.timestamp);
    }
      /**
     * @notice Returns the current value of the counter.
     * @dev This is a getter function for the `counter` state variable.
     * @return The current value of the counter.
     */
    function getCount() public view  returns (uint)  {
        return counter;
    }
     /**
     * @notice Sets the counter to a specific value.
     * @dev This function updates the counter to `_num` and emits a `CountIncreased` event.
     * @param _num The new value to set the counter to.
     */
    function stateChanging(uint _num) public {
        counter = _num;
        emit CountIncreased(counter, block.timestamp);
    }
        
}