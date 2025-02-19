

//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

contract SimpleCounter {
    uint256 public count;

    // Event to log count updates
    event CountUpdated(uint256 newCount);
    event CounterIncreased(uint amount, uint when);
    event CountDecreased(uint amount, uint when);

    //function to increase counter by a value
    function increasedByOne() public {
        require(count < type(uint256).max, "cannot increase beyond max uint");
        count++;
        emit CounterIncreased(count, block.timestamp);
    }

    //function to increase by value
    function increaseValueBy(uint _value) public {
        require(_value > 0, "Value must be greater than zero");

        //check for overflow
        uint256 newCount = count + _value;
        require(newCount > count, "overflow detected");
        count = newCount;
        emit CounterIncreased(newCount, block.timestamp);
    }

    //function to decrease conter by one
    function decreaseByOne() public {
        require(count > 0, "Can not decrease below  zero");
        count--;
        emit CountDecreased(count, block.timestamp);
    }

        // Function to decrease counter by a value
    function decreaseValueBy(uint256 _value) public {
        require(_value > 0, "Value must be greater than zero");
        require(count >= _value, "Underflow: Can not decrease below zero");

        // Check for underflow
        uint256 newCount = count - _value;
        require(newCount < count, "Underflow: Count would go below zero");

        count = newCount;
        emit CountUpdated(count);
        emit CountDecreased(_value, block.timestamp);
    }

    //function to reset count
    function resetCount() public {
        require(count > 0, "Counter is already zero");
        uint256 previousCount = count;
        count = 0;
        emit CountDecreased(previousCount, block.timestamp);
    }


    //function to get count
    function getCount() public view returns (uint){
        return count;
    }


    //function to return the maxvalue of uint256
    function checkMaxValue() public pure returns (uint256) {
        unchecked {
            return type(uint256).max;
        }
    }


}
