// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SimpleCounter {
    /// **********  variables **********
    uint256 public count;
    /// **********  of Count variables **********

    /// **** Events ****
    event CountIncreased(uint amount, uint when);
    event CountDecreased(uint amount, uint when);
    /// **** End of Events ****

    /// **********  functions **********
    function increment() public {
        count++;
    }

    function increaseByOne() public {
        require(count < getMaxUint256(), "cannot increase beyond max uint");
        count++;
        emit CountIncreased(count, now);
    }

    function increaseByValue(uint _value) public {
        require(count + _value > count, "cannot increase beyond max uint");
        require(count + _value <= getMaxUint256(), "cannot increase beyond max uint");
        count += _value;
        emit CountIncreased(count, now);
    }

    function decreaseByOne() public {
        require(count > 0, "cannot decrease below 0");
        count--;
        emit CountDecreased(count, now);
    }

    function decreaseByValue(uint _value) public {
        require(count > 0, "cannot decrease below 0");
        require(count - _value < count, "cannot decrease below 0");
        count -= _value;
        emit CountDecreased(count, now);
    }

    function resetCount() public {
        count = 0;
        emit CountDecreased(count, now);
    }

    function getCount() public view returns (uint) {
        return count;
    }

    function getMaxUint256() public pure returns (uint) {
        unchecked {
            return type(uint256).max; /// 2**256 - 1
        }
    }
    /// ********** End of functions **********
}
