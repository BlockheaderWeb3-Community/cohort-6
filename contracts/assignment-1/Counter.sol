// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Counter {
     uint public count ;
    // event 
     event countIncreased(uint amount , uint when);
     event countDecreased(uint amount ,uint when);

     // functions 
     function increaseByOne() public {
        count ++;
        require(type(uint256).max > count, "Overflow operation prevented");
         emit countIncreased (1, block.timestamp);
     }
    // functions to increase the  
    function increaseByValue( uint _value) public  {
        count += _value;
         require(type(uint256).max > count, "Overflow operation prevented");
        emit countIncreased(_value, block.timestamp);
    }

      // functions
     function DecreaseByOne() public {
        require(count >= uint(0), "Overflow operation prevented");
            count--;
        emit  countDecreased(1, block.timestamp);
     }
      // function 
     function DecreaseByValue(uint _value) public {
        require(count >= 0,"Overflow operation prevented");
        count -= _value;
         
        emit countDecreased(_value, block.timestamp);
     }
     // functions
      function resetCount() public {
        count = 0;
        emit countDecreased(0, block.timestamp);
      }
       // functions
       function getCount() public view returns(uint){
           return count ;
       }
       // functions
       function  getMaxUint256() public pure returns(uint) {
            unchecked{
                return uint(0) - 1;
            }
       }


}