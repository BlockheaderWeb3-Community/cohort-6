# Assignment2
here's link to [assignment 2](../contracts/Assignment2/studentRegistry.Uka.sol)

# Student Registry Smart Contract

## Overview
The **StudentRegistry** smart contract manages student records, attendance, and interests. It allows users to register as students, track attendance, manage interests, and retrieve student details securely.

## Features
- **Register Students**: Users can register as students with a name and predefined interests.
- **Manage Attendance**: Attendance status can be marked as "Present" or "Absent".
- **Interest Management**: Students can add or remove interests (max 5 interests per student).
- **Retrieve Student Data**: Fetch student names, attendance, and interests.
- **Ownership Control**: Only the contract owner can transfer ownership.
- **Event Logging**: Emits events for critical actions (e.g., student registration, attendance updates, interest changes, and ownership transfer).

## Smart Contract Details
- **Author**: Goodness
- **Compiler Version**: Solidity 0.8.0
- **License**: UNLICENSED

## Functions
### 1. `registerStudent()`
Registers a student with a default name "Goodness" and predefined interests.
- Emits `createdStudent` event.

### 2. `registerNewStudent(string _name)`
Registers a student with a specified name.
- Emits `createdStudent` event.

### 3. `markAttendance(address _address, Attendance _attendance)`
Updates a student's attendance status.
- Emits `AttendanceStatus` event.

### 4. `addInterest(address _address, string _interest)`
Adds an interest to a student's profile (max 5 interests).
- Ensures no duplicate interests.
- Emits `InterestAdded` event.

### 5. `removeInterest(address _address, string _interest)`
Removes a specified interest from a student's profile.
- Emits `InterestRemoved` event.

### 6. `getStudentName(address _address)`
Retrieves a student's name.
- `view` function (read-only).

### 7. `getStudentAttendance(address _address)`
Retrieves a student's attendance status.
- `view` function (read-only).

### 8. `getStudentInterests(address _address)`
Retrieves a student's interests.
- `view` function (read-only).

### 9. `transferOwnership(address _newOwner)`
Transfers contract ownership to another address.
- Only the owner can execute this function.
- Emits `OwnershipTransferred` event.

## Events
### `createdStudent(string name, Attendance attendance, string[] interest)`
- Triggered when a new student is registered.

### `AttendanceStatus(address studentAddress, Attendance attendanceStatus)`
- Triggered when attendance is updated.

### `InterestAdded(address studentAddress, string interest)`
- Triggered when an interest is added.

### `InterestRemoved(address studentAddress, string interest)`
- Triggered when an interest is removed.

### `OwnershipTransferred(address previousOwner, address newOwner)`
- Triggered when contract ownership is transferred.

## Deployment
1. Deploy the contract using **Remix**, **Hardhat**, or **Truffle**.
2. Interact with the contract using **Ethers.js** or **Web3.js**.
3. Ensure gas estimation is done properly when executing state-changing functions.

## License
This contract is licensed as **UNLICENSED**.

## Author
**Goodness**

