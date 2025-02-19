# Submissions for Assignment 2
---
Here is a link to the [StudentRegistry.sol](../../contracts/assignment-2/StudentRegistry.sol) file.


## Implementation Notes:
- I have added a constructor to the contract to set the owner to the contract deployer.
- For the second functionality, I changed the function to take an address as an argument and check if the student exists using the `studentExists` modifier. This was done because i noticed our `studentDoesNotExist` modifier was expecting an address not a name
- I have added a `transferOwnership` function to transfer the ownership of the contract to a new address as required.
- Every other functionality is as per the requirements.

## Testing:
- Every function has been tested on remix and the events have been checked to ensure they are being emitted as expected.
- I also made sure to test for cases that needed input validation and made sure the functions behaved as expected.