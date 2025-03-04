// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

/**
 * @title Counter Contract
 * @notice A simple counter contract that supports incrementing and decrementing operations.
 * @dev Provides functions to increment, decrement and adjust the counter by a specified value.
 */

contract Counter {
    /**
     * @notice The current count value.
     * @dev Public state variable initialized to zero.
     */
    uint public countVal = 0;

    /**
     * @notice Retrieves the current count value.
     * @return The current counter value.
     */
    function getCount() public view returns (uint) {
        return countVal;
    }

    /**
     * @notice Increments the counter by one.
     * @dev Ensures that the counter does not exceed the maximum value defined by runner().
     */
    function increment() public {
        uint maxValue = runner();
        require(countVal < maxValue);
        countVal++;
    }

    /**
     * @notice Decrements the counter by one.
     * @dev Prevents the counter from decrementing below zero.
     */
    function decrement() public {
        require(countVal > 0, "Counter cannot be negative");
        countVal--;
    }

    /**
     * @notice Increments the counter by a specified positive value.
     * @param _val The value to add to the current count.
     * @dev Validates that _val is greater than zero and that the resulting count does not exceed the maximum value.
     */
    function incrementByVal(uint _val) public {
        uint maxValue = runner();
        require(_val > 0, "Must be greater than zero");
        require(countVal + _val <= maxValue, "Counter cannot be negative");
        countVal += _val;
    }

    /**
     * @notice Decrements the counter by a specified positive value.
     * @param _val The value to subtract from the current count.
     * @dev Validates that _val is greater than zero and that the current count is sufficient to subtract _val without underflow.
     */
    function decrementByVal(uint _val) public {
        require(_val > 0, "Must be greater than zero");
        require(countVal >= _val, "Underflow: Cannot decrement below zero"); // Prevent underflow

        countVal -= _val;
    }

    /**
     * @notice Computes the maximum value for a uint256.
     * @return The maximum possible value of a uint256.
     * @dev Uses unchecked arithmetic to derive the maximum uint256 value.
     */
    function runner() public pure returns (uint) {
        unchecked {
            return uint256(0) - 1;
        }
    }
}
