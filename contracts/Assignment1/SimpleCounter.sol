
//SPDX-License-Identifier:MIT
pragma solidity ^0.8.26;

contract SimpleCounter {
    uint256 public count;

    event CountUpdated(uint256 newCount);
    event CounterIncreased(uint amount, uint when);
    event CountDecreased(uint amount, uint when);

    function increasedByOne() public {
        require(count < type(uint256).max, "cannot increase beyond max uint");
        count++;
        emit CounterIncreased(count, block.timestamp);
    }

    function increaseValueBy(uint _value) public {
        require(_value > 0, "Value must be greater than zero");

        uint256 newCount = count + _value;
        require(newCount > count, "overflow detected");
        count = newCount;
        emit CounterIncreased(newCount, block.timestamp);
    }

    function decreaseByOne() public {
        require(count > 0, "Can not decrease below  zero");
        count--;
        emit CountDecreased(count, block.timestamp);
    }

    function decreaseValueBy(uint256 _value) public {
        require(_value > 0, "Value must be greater than zero");
        require(count >= _value, "Underflow: Can not decrease below zero");

        uint256 newCount = count - _value;
        require(newCount < count, "Underflow: Count would go below zero");

        count = newCount;
        emit CountUpdated(count);
        emit CountDecreased(_value, block.timestamp);
    }

    function resetCount() public {
        require(count > 0, "Counter is already zero");
        uint256 previousCount = count;
        count = 0;
        emit CountDecreased(previousCount, block.timestamp);
    }

    function getCount() public view returns (uint){
        return count;
    }

    function checkMaxValue() public pure returns (uint256) {
        unchecked {
            return type(uint256).max;
        }
    }


}