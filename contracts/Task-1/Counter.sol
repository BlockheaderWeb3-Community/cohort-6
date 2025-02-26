// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;


contract Counter {

    uint public count;

    
    event CountIncreased(uint amount, uint when);

    
    event CountDecreased(uint amount, uint when);

   
    function increaseByOne() public {
        require(count < getMaxUint256(), "cannot increase beyond max uint");
        count += 1;
        emit CountIncreased(count, block.timestamp);
    }

    
    function increaseByValue(uint _value) public {
        require(count + _value >= count, "cannot increase beyond max uint");
        count += _value;
        emit CountIncreased(count, block.timestamp);
    }

    
    function decreaseByOne() public {
        require(count > 0, "cannot decrease below 0");
        count -= 1;
        emit CountDecreased(count, block.timestamp);
    }

    
    function decreaseByValue(uint _value) public {
        require(count >= _value, "cannot decrease below 0");
        count -= _value;
        emit CountDecreased(count, block.timestamp);
    }

   
    function resetCount() public {
        count = 0;
        emit CountDecreased(count, block.timestamp);
    }

    
    function getCount() public view returns (uint) {
        return count;
    }

   
    function getMaxUint256() public pure returns (uint) {
        unchecked {
            return uint(0) - 1;
        }
    }
}
