// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Counter{

    //state variable: to keep track of count specified
    uint public counter = 0;

    //event declaration
    //countIncreased: event to be emitted once count value increases, alongside the time it occured
    event countIncreased(uint amount, uint when);
    //countDecreased: event to be emitted once count value decreases, alongside the time it occured
    event countDecreased(uint amount, uint when);

    //incrementing count by one
    function increaseByOne() public{
        counter++;
        //validation: to ensure arithmetic overflow of uint256 type
        require(type(uint256).max > counter, "cannot increase beyond max uint");
        emit countIncreased(1, block.timestamp);
    }
    
    //decrementing count by 1
    function decreaseByOne() public {
       counter--;
       //validation: to ensure arithmetic underflow of uint256 type 
       require(counter >= uint(0), "cannot decrease beyond zero");
       emit countDecreased(1, block.timestamp);
    }

    //increases the counter by a given value
    function increaseByValue(uint _value) public{
        counter += _value;
        //validation: to ensure arithmetic overflow of uint256 type 
        require(type(uint256).max > counter, "cannot increase beyond max uint");
        emit countIncreased(_value, block.timestamp);
    }

    //increases the counter by a given value
    function decreaseByValue(uint _value) public{
        counter -= _value;
        //validation: to ensure arithmetic underflow of uint256 type
        require(counter >= uint(0), "cannot decrease beyond zero"); 
        emit countDecreased(_value, block.timestamp);
    }

    //resets the count variable to zero(0)
    function resetCount() public {
       counter = 0;
       emit countDecreased(counter, block.timestamp);
    }

    //returns the value of counter
    function getCount()public view returns (uint){
        return counter;
    }
    //returns the max value of a uint256 
    function getMaxUint256()public pure returns (uint){
        //using unchecked block: to underflow a uint256 without reverting
        unchecked{
            return uint(0) - 1;
        }
    }
}