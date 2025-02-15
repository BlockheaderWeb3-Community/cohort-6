// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// @title A contract that manages a simple numerical counter
// @ author Sylvia Nnoruka
// @ notice You can use this contact to increase, decrease, and reset the counter, while also emitting events to track changes
contract Count {
    // @ notice event for when the count increase or decrease
    event Updated (uint count,address updatedby);

    // @ notice Declared a state variable
     uint public count = 0; 

    //  @ notice wrote a function that increases the count
     function increase()public{

        // @ notice this count shouldnt increase beyound uint256
        require (count < type(uint).max, "cannot increase beyond max uint");
        count += 1;

        // @ notice triggers the updated event
         emit Updated (count, msg.sender);

     }
    //  @notice decreases the count by 1 and triggers the Updated event
     function decrease()public {
        require (count > 0, "cannot be less than 0");
        count -= 1;

        emit Updated (count, msg.sender);
     }
       // @notice reset the count by 0 and triggers the Updated event
     function reset () public{
         count = 0;

         emit Updated (count, msg.sender);
     }

    //  @notice a getter function that gets the value of count
     function getCount() public view returns(uint) {
       return count;
     }
    
    // @notice  returns the maximum possible value of a uint256.
    function getMaxUint256() public pure returns(uint){
        unchecked{
            return uint256(0) - 1;
        }
    }
    
    
}