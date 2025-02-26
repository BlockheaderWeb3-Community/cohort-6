// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/// @title Counter Contract Implementation
/// @author FRANKHOOD
/// @notice this contract defines the count and maximum value of the count
/// @dev All function calls are currently implemented without side effects
contract Counter{
    uint public count = 0;
    uint maxValue = getMaxUint256 ();

/// @notice this event is emitted when the count is increased
/// @param amount the value of the count after increasing
/// @param timestamp the time the count increased
event CountIncreased(uint amount, uint timestamp);

/// @notice this event is emitted when the count is decreased
/// @param amount the value of the count after decreasing
/// @param timestamp the time the count decreased
event CountDecreased(uint amount, uint timestamp);

/// @notice this function increases the count by 0ne
/// @notice this function is reverted if it exceeds the maxValue
function increaseByOne() public {
    require(count < maxValue, "cannot increase beyond max uint");
    count ++;
    emit CountIncreased(count, block.timestamp);
}

/// @notice this function increases the count by a value that must be greater than 0
/// @notice this function is reverted if it exceeds the maxValue
function increaseByValue(uint _value) public {
    require (_value > 0);
    require(count < maxValue, "cannot increase beyond max uint");
    count += _value;
    emit CountIncreased(count, block.timestamp);
}

/// @notice this function decreases the count by 0ne 
/// @notice this function is reverted if the value of count is less than 1
function decreaseByOne() public {
    require(count >= 1,"cannot decrease below 0");
    count --;
    emit CountDecreased(count, block.timestamp);
}

/// @notice this function decreases the count by a value greater than or equal to one  
/// @notice this function is reverted if the result is greater than maxValue
function decreaseByValue(uint _value) public {
    require(count >= 1,"cannot decrease below 0");
    require(count + _value <= maxValue);
    count += _value;
    emit CountDecreased(count, block.timestamp);
}

/// @notice this function resets the count to original value - 0
function resetCount() public {
    count = 0;
    emit CountDecreased(count, block.timestamp);
}

/// @notice this function returns the current value of count
function getCount() public view returns (uint){
    return count;
}

/// @notice this function returns the maximum value of count
function getMaxUint256() public pure returns (uint){
    unchecked {
        return uint256 (0)-1;
    }
}
}